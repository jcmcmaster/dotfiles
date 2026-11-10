#load "Pr.fs"

open System
open System.Collections.Generic
open System.IO
open System.Text.Json.Nodes
open Pr

let equal expected actual =
    if expected <> actual then
        failwithf "Expected %A, got %A" expected actual

let throws action =
    let error =
        try
            action ()
            None
        with ex ->
            Some ex

    if Option.isNone error then
        failwith "Expected failure."

let parse (json: string) = JsonNode.Parse json
let ok json = 0, json

let fixture (replies: (int * string) list) (watchCodes: int list) =
    let replies = Queue<int * string>(replies)
    let codes = Queue<int>(watchCodes)
    let calls = ResizeArray<Output * string list>()
    let clock = ref TimeSpan.Zero

    let gh output args =
        calls.Add((output, args))

        match output with
        | Capture -> replies.Dequeue()
        | Inherit -> (if codes.Count > 0 then codes.Dequeue() else 0), ""

    let runtime =
        { Gh = gh
          Elapsed = (fun () -> clock.Value)
          Sleep = (fun duration -> clock.Value <- clock.Value + duration) }

    runtime, calls, clock

let watches calls =
    calls
    |> Seq.choose (function
        | Inherit, "run" :: "watch" :: id :: _ -> Some id
        | _ -> None)
    |> Seq.toList

let run id =
    parse (
        sprintf
            """{"id":%d,"path":"dynamic/agents/copilot-pull-request-reviewer","head_sha":"current","head_branch":"feature","pull_requests":[]}"""
            id
    )

let nodes values =
    values
    |> List.map (fun (node: JsonNode) -> node.ToJsonString())
    |> String.concat ","

let runs pages =
    pages
    |> List.map (fun page -> sprintf """{"workflow_runs":[%s]}""" (nodes page))
    |> String.concat ","
    |> sprintf "[%s]"

let head = ok """{"headRefOid":"current","headRefName":"feature"}"""
let polls page = List.replicate 7 (ok page)

let snapshot () =
    parse
        """{"id":"PR","comments":{"nodes":[],"pageInfo":{"hasNextPage":false}},"reviews":{"nodes":[],"pageInfo":{"hasNextPage":false}},"reviewThreads":{"nodes":[],"pageInfo":{"hasNextPage":false}}}"""

let first (snapshot: JsonNode) =
    ok (sprintf """{"data":{"repository":{"pullRequest":%s}}}""" (snapshot.ToJsonString()))

let page more cursor values =
    parse (sprintf """{"pageInfo":{"hasNextPage":%b,"endCursor":"%s"},"nodes":[%s]}""" more cursor (nodes values))

let next field (page: JsonNode) =
    ok (sprintf """{"data":{"node":{"%s":%s}}}""" field (page.ToJsonString()))

let tests =
    [ "absence polls for thirty seconds",
      fun () ->
          let runtime, calls, clock = fixture (head :: polls (runs [ [] ])) []

          equal
              (Some "No Copilot action found for owner/repo#7 at current in 30s.")
              (waitCopilot runtime "owner/repo" 7)

          equal (TimeSpan.FromSeconds 30.0) clock.Value
          equal 8 calls.Count
          equal [] (watches calls)

      "delayed action is detected",
      fun () ->
          let replies = head :: ok (runs [ [] ]) :: List.replicate 6 (ok (runs [ [ run 1 ] ]))
          let runtime, calls, clock = fixture replies []
          equal None (waitCopilot runtime "owner/repo" 7)
          equal (TimeSpan.FromSeconds 30.0) clock.Value
          equal [ "1" ] (watches calls)

      "an older completed run does not hide a new review",
      fun () ->
          let old, fresh = run 1, run 2
          old.["status"] <- JsonValue.Create "completed"
          fresh.["status"] <- JsonValue.Create "in_progress"

          let replies =
              head
              :: ok (runs [ [ old ] ])
              :: ok (runs [ [ old; fresh ] ])
              :: List.replicate 5 (ok (runs [ [ fresh ] ]))

          let runtime, calls, clock = fixture replies []
          equal None (waitCopilot runtime "owner/repo" 7)
          equal (TimeSpan.FromSeconds 30.0) clock.Value
          equal [ "1"; "2" ] (watches calls)

      "filters SHA, path and branch across pages, including nullable associations",
      fun () ->
          let old, other, branch, legacy, linked, unrelated =
              run 1, run 2, run 3, run 4, run 5, run 6

          old.["head_sha"] <- JsonValue.Create "old"
          other.["path"] <- JsonValue.Create "ci.yml"
          branch.["head_branch"] <- JsonValue.Create "other"
          legacy.["head_branch"] <- JsonValue.Create "refs/pull/7/head"
          legacy.["path"] <- JsonValue.Create "dynamic/copilot-pull-request-reviewer/copilot-pull-request-reviewer"
          linked.["head_branch"] <- null
          linked.["pull_requests"] <- parse """[{"number":7}]"""
          unrelated.["head_branch"] <- null
          unrelated.["pull_requests"] <- null

          let runtime, calls, _ =
              fixture (head :: polls (runs [ [ old; other; branch ]; [ legacy; linked; unrelated ] ])) []

          equal None (waitCopilot runtime "owner/repo" 7)
          equal [ "4"; "5" ] (watches calls)
          let _, args = calls.[1]
          equal true (List.contains "repos/owner/repo/actions/runs?head_sha=current&per_page=100" args)

      "waits for all runs despite failure",
      fun () ->
          let runtime, calls, _ = fixture (head :: polls (runs [ [ run 1; run 2 ] ])) [ 1; 0 ]
          throws (fun () -> waitCopilot runtime "owner/repo" 7 |> ignore)
          equal [ "1"; "2" ] (watches calls)

      "API failure is not absence",
      fun () ->
          let runtime, calls, clock = fixture [ head; 1, "" ] []
          throws (fun () -> waitCopilot runtime "owner/repo" 7 |> ignore)
          equal TimeSpan.Zero clock.Value
          equal [] (watches calls)

      "small snapshots use one GraphQL call",
      fun () ->
          let runtime, calls, _ = fixture [ first (snapshot ()) ] []
          let result = comments runtime "owner/repo" 7
          equal "PR" (result.["id"].GetValue<string>())
          equal 1 calls.Count
          let output, args = calls.[0]
          equal Capture output
          equal [ "api"; "graphql" ] (List.take 2 args)

      "paginates every outer connection",
      fun () ->
          for field in [ "comments"; "reviews"; "reviewThreads" ] do
              let initial = snapshot ()
              initial.[field] <- page true "next" []

              let item =
                  parse """{"id":"NEW","comments":{"nodes":[],"pageInfo":{"hasNextPage":false}}}"""

              let runtime, calls, _ =
                  fixture [ first initial; next field (page false "" [ item ]) ] []

              let result = comments runtime "owner/repo" 7
              equal "NEW" (result.[field].["nodes"].[0].["id"].GetValue<string>())
              equal 2 calls.Count
              equal true (List.contains "cursor=next" (snd calls.[1]))

      "paginates replies inside a thread",
      fun () ->
          let initial = snapshot ()
          let thread = parse """{"id":"THREAD"}"""
          thread.["comments"] <- page true "reply" [ parse """{"id":"one"}""" ]
          initial.["reviewThreads"].["nodes"].AsArray().Add thread

          let runtime, calls, _ =
              fixture [ first initial; next "comments" (page false "" [ parse """{"id":"two"}""" ]) ] []

          let result = comments runtime "owner/repo" 7

          let replies =
              result.["reviewThreads"].["nodes"].[0].["comments"].["nodes"].AsArray()

          equal [ "one"; "two" ] (replies |> Seq.map (fun node -> node.["id"].GetValue<string>()) |> Seq.toList)
          equal true (List.contains "id=THREAD" (snd calls.[1]))
          equal true ((snd calls.[1]).[3].Contains "PullRequestReviewThread")

      "follows multiple pages",
      fun () ->
          let initial = snapshot ()
          initial.["comments"] <- page true "first" []

          let replies =
              [ first initial
                next "comments" (page true "second" [ run 1 ])
                next "comments" (page false "" [ run 2 ]) ]

          let runtime, calls, _ = fixture replies []
          let result = comments runtime "owner/repo" 7
          equal 3 calls.Count
          equal true (List.contains "cursor=second" (snd calls.[2]))
          equal 2 (result.["comments"].["nodes"].AsArray().Count)

      "pagination failure emits no partial snapshot",
      fun () ->
          let initial = snapshot ()
          initial.["comments"] <- page true "next" []
          let runtime, _, _ = fixture [ first initial; 1, "" ] []
          use output = new StringWriter()

          throws (fun () ->
              execute runtime [| "comments"; "owner/repo"; "7" |]
              |> Option.iter output.WriteLine)

          equal "" (output.ToString())

      "missing PR fails",
      fun () ->
          let runtime, _, _ =
              fixture [ ok """{"data":{"repository":{"pullRequest":null}}}""" ] []

          throws (fun () -> comments runtime "owner/repo" 7 |> ignore)

      "invalid arguments fail before calling GitHub",
      fun () ->
          for args in
              [ [||]
                [| "oops"; "owner/repo"; "7" |]
                [| "wait"; "owner"; "7" |]
                [| "wait"; "owner/repo"; "0" |] ] do
              let runtime, calls, _ = fixture [] []
              throws (fun () -> execute runtime args |> ignore)
              equal 0 calls.Count ]

for name, test in tests do
    test ()
    printfn "PASS %s" name

printfn "%d tests passed." tests.Length
