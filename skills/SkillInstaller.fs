module SkillInstaller

open System
open System.ComponentModel
open System.Diagnostics
open YamlDotNet.Serialization
open YamlDotNet.Serialization.NamingConventions

type Skill = { Repository: string; Name: string }
type Options = { WhatIf: bool }

[<CLIMutable>]
type RepositorySkills =
    { Repository: string
      Skills: string array }

let usage = "Usage: dotnet fsi skills/init.fsx -- [--what-if]"

let parseArgs args =
    let rec parse options = function
        | [] -> options
        | "--what-if" :: rest -> parse { WhatIf = true } rest
        | _ -> invalidArg (nameof args) usage

    match args with
    | [| "--help" |] -> None
    | _ -> Some(parse { WhatIf = false } (Array.toList args))

let parseManifest (yaml: string) =
    let entries =
        DeserializerBuilder()
            .WithNamingConvention(CamelCaseNamingConvention.Instance)
            .Build()
            .Deserialize<RepositorySkills array>(yaml)

    if isNull entries then
        failwith "skills.yml must contain a list of repositories and their skills."

    entries
    |> Array.collect (fun entry ->
        if
            isNull (box entry)
            || String.IsNullOrWhiteSpace entry.Repository
            || isNull entry.Skills
            || Array.isEmpty entry.Skills
            || Array.exists String.IsNullOrWhiteSpace entry.Skills
        then
            failwith
                "Each entry in skills.yml must specify a repository and a non-empty skills list with non-blank names."

        entry.Skills
        |> Array.map (fun name ->
            { Repository = entry.Repository
              Name = name }))
    |> Array.toList

let runGh (args: string list) =
    let start = ProcessStartInfo("gh", UseShellExecute = false)
    args |> List.iter start.ArgumentList.Add

    try
        use child = Process.Start start
        child.WaitForExit()
        child.ExitCode
    with :? Win32Exception as error when error.NativeErrorCode = 2 ->
        failwith "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."

let install gh write options (skills: Skill list) =
    for skill in skills do
        for agent in [ "github-copilot"; "opencode" ] do
            let args =
                [ "skill"; "install"; skill.Repository; skill.Name; "--agent"; agent; "--scope"; "user"; "--force" ]

            if options.WhatIf then
                write ("What if: gh " + String.concat " " args)
            else
                let code = gh args

                if code <> 0 then
                    failwithf
                        "Failed to install %s/%s for %s (user scope) (gh exited with %d)."
                        skill.Repository
                        skill.Name
                        agent
                        code
