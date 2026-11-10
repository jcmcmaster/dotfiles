module Pr

open System
open System.Text.Json
open System.Text.Json.Nodes
open System.Text.RegularExpressions

type Output =
    | Capture
    | Inherit

type Runtime =
    { Gh: Output -> string list -> int * string
      Elapsed: unit -> TimeSpan
      Sleep: TimeSpan -> unit }

let private ghJson runtime args =
    let code, output = runtime.Gh Capture args

    if code <> 0 then
        failwithf "gh failed (exit %d)." code

    match JsonNode.Parse output with
    | null -> failwith "GitHub returned no JSON."
    | json -> json

let private graphql runtime query args =
    ghJson runtime ([ "api"; "graphql"; "-f"; "query=" + query ] @ args)

let private text (node: JsonNode) (field: string) = node.[field].GetValue<string>()
let private items (node: JsonNode) = node.AsArray() :> seq<JsonNode>

let waitCopilot runtime repo number =
    let head =
        ghJson
            runtime
            [ "pr"
              "view"
              string number
              "--repo"
              repo
              "--json"
              "headRefOid,headRefName" ]

    let sha = text head "headRefOid"
    let branches = set [ text head "headRefName"; $"refs/pull/{number}/head" ]
    let started = runtime.Elapsed()

    let matches (run: JsonNode) =
        let branch = Option.ofObj run.["head_branch"] |> Option.map _.GetValue<string>()

        let linked =
            match run.["pull_requests"] with
            | null -> false
            | prs -> items prs |> Seq.exists (fun pr -> pr.["number"].GetValue<int>() = number)

        (text run "path").Contains "copilot-pull-request-reviewer"
        && text run "head_sha" = sha
        && (Option.exists (fun branch -> Set.contains branch branches) branch || linked)

    let rec discover seen =
        // GitHub filters by commit before pagination; this is not repository-wide history.
        let pages =
            ghJson
                runtime
                [ "api"
                  "--paginate"
                  "--slurp"
                  $"repos/{repo}/actions/runs?head_sha={sha}&per_page=100" ]

        let found =
            items pages
            |> Seq.collect (fun page -> items page.["workflow_runs"])
            |> Seq.filter matches
            |> Seq.map (fun run -> run.["id"].GetValue<int64>())
            |> Set.ofSeq

        let seen = Set.union seen found
        let remaining = TimeSpan.FromSeconds 30.0 - (runtime.Elapsed() - started)

        if remaining <= TimeSpan.Zero then
            seen
        else
            runtime.Sleep(min remaining (TimeSpan.FromSeconds 5.0))
            discover seen

    let runs = discover Set.empty

    if Set.isEmpty runs then
        Some $"No Copilot action found for {repo}#{number} at {sha} in 30s."
    else
        // Eager evaluation ensures every run is awaited, even when an earlier run fails.
        let results =
            runs
            |> Set.toList
            |> List.map (fun id ->
                runtime.Gh
                    Inherit
                    [ "run"
                      "watch"
                      string id
                      "--repo"
                      repo
                      "--exit-status"
                      "--interval"
                      "5" ]
                |> fst)

        if List.exists ((<>) 0) results then
            failwith "Copilot action watch failed; investigate before finishing."

        None

let private connection field selection after =
    sprintf "%s(first: 100%s) { pageInfo { hasNextPage endCursor } nodes { %s } }" field after selection

let private complete runtime (node: JsonNode) kind (fields: (string * string) list) =
    for field, selection in fields do
        let value = node.[field]

        while value.["pageInfo"].["hasNextPage"].GetValue<bool>() do
            let query =
                sprintf
                    "query($id: ID!, $cursor: String!) { node(id: $id) { ... on %s { %s } } }"
                    kind
                    (connection field selection ", after: $cursor")

            let result =
                graphql
                    runtime
                    query
                    [ "-f"
                      "id=" + text node "id"
                      "-f"
                      "cursor=" + text value.["pageInfo"] "endCursor" ]

            let page = result.["data"].["node"].[field]

            for item in items page.["nodes"] do
                value.["nodes"].AsArray().Add(item.DeepClone())

            value.["pageInfo"] <- page.["pageInfo"].DeepClone()

let comments runtime (repo: string) number =
    let owner, name =
        match repo.Split('/') with
        | [| owner; name |] -> owner, name
        | _ -> invalidArg (nameof repo) "Expected OWNER/REPO."

    let comment = "id author { login } body url createdAt updatedAt"
    let inlineComment = comment + " databaseId replyTo { id }"

    let fields =
        [ "comments", comment
          "reviews", comment + " state submittedAt commit { oid }"
          "reviewThreads",
          "id path line originalLine isResolved isOutdated "
          + connection "comments" inlineComment "" ]

    let selections =
        fields
        |> List.map (fun (field, selection) -> connection field selection "")
        |> String.concat "\n"

    let query =
        """query($owner: String!, $name: String!, $number: Int!) {
          repository(owner: $owner, name: $name) {
            pullRequest(number: $number) { id number url state headRefOid CONNECTIONS }
          }
        }"""
            .Replace("CONNECTIONS", selections)

    let result =
        graphql
            runtime
            query
            [ "-f"
              "owner=" + owner
              "-f"
              "name=" + name
              "-F"
              "number=" + string number ]

    let pr = result.["data"].["repository"].["pullRequest"]

    if isNull pr then
        failwith "PR not found."

    complete runtime pr "PullRequest" fields

    for thread in items pr.["reviewThreads"].["nodes"] do
        complete runtime thread "PullRequestReviewThread" [ ("comments", inlineComment) ]

    pr

let execute runtime args =
    let usage = "Usage: dotnet fsi pr.fsx -- {wait|comments} OWNER/REPO PR"

    match args with
    | [| "--help" |] -> Some usage
    | [| mode; repo; raw |] when mode = "wait" || mode = "comments" ->
        match Int32.TryParse raw with
        | true, number when number > 0 && Regex.IsMatch(repo, @"^[^/\s]+/[^/\s]+$") ->
            match mode with
            | "wait" -> waitCopilot runtime repo number
            | _ -> Some((comments runtime repo number).ToJsonString(JsonSerializerOptions(WriteIndented = true)))
        | _ -> invalidArg (nameof args) usage
    | _ -> invalidArg (nameof args) usage
