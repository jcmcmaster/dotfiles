module SkillInstaller

open System
open System.Collections.Generic
open System.ComponentModel
open System.Diagnostics
open YamlDotNet.Serialization

type Skill = { Repository: string; Name: string }
type Options = { Force: bool; WhatIf: bool }

let usage = "Usage: dotnet fsi skills/init.fsx -- [--force] [--what-if]"

let parseArgs args =
    let rec parse options = function
        | [] -> options
        | "--force" :: rest -> parse { options with Force = true } rest
        | "--what-if" :: rest -> parse { options with WhatIf = true } rest
        | _ -> invalidArg (nameof args) usage

    match args with
    | [| "--help" |] -> None
    | _ -> Some(parse { Force = false; WhatIf = false } (Array.toList args))

let parseManifest (yaml: string) =
    let entries =
        DeserializerBuilder().Build().Deserialize<Dictionary<string, string> array>(yaml)

    if isNull entries then
        failwith "skills.yml must contain a list of repository/skill pairs."

    entries
    |> Array.map (fun entry ->
        let field name =
            match entry with
            | null -> failwith "Each entry in skills.yml must specify repository and skill."
            | _ ->
                match entry.TryGetValue name with
                | true, value when not (String.IsNullOrWhiteSpace value) -> value
                | _ -> failwith "Each entry in skills.yml must specify repository and skill."

        { Repository = field "repository"
          Name = field "skill" })
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

let install gh write options skills =
    for skill in skills do
        for agent in [ "github-copilot"; "opencode" ] do
            let args =
                [ "skill"; "install"; skill.Repository; skill.Name; "--agent"; agent; "--scope"; "user" ]
                @ (if options.Force then [ "--force" ] else [])

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
