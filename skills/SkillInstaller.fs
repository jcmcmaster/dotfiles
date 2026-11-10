module SkillInstaller

open System
open System.Collections.Generic
open System.ComponentModel
open System.Diagnostics
open YamlDotNet.Serialization

type Skill = { Repository: string; Name: string }
type Options = { Force: bool; WhatIf: bool; Verbose: bool }

type CommandResult =
    { ExitCode: int
      StandardOutput: string
      StandardError: string }

type Runtime =
    { Gh: string list -> CommandResult
      Write: string -> unit
      WriteError: string -> unit
      ConfirmOverwrite: Skill -> string -> bool option }

let usage = "Usage: dotnet fsi skills/init.fsx -- [--force] [--what-if] [--verbose]"

let parseArgs args =
    let rec parse options = function
        | [] -> options
        | "--force" :: rest -> parse { options with Force = true } rest
        | "--what-if" :: rest -> parse { options with WhatIf = true } rest
        | "--verbose" :: rest -> parse { options with Verbose = true } rest
        | _ -> invalidArg (nameof args) usage

    match args with
    | [| "--help" |] -> None
    | _ -> Some(parse { Force = false; WhatIf = false; Verbose = false } (Array.toList args))

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

let runCommand executable (args: string list) =
    let start =
        ProcessStartInfo(
            executable,
            UseShellExecute = false,
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            StandardOutputEncoding = Text.Encoding.UTF8,
            StandardErrorEncoding = Text.Encoding.UTF8
        )

    // The wrapper owns confirmations; never wait for an invisible child prompt.
    start.Environment["GH_PROMPT_DISABLED"] <- "1"
    args |> List.iter start.ArgumentList.Add
    use child = Process.Start start
    child.StandardInput.Close()

    // Drain both pipes concurrently so a large diagnostic cannot deadlock the child.
    let output = child.StandardOutput.ReadToEndAsync()
    let errors = child.StandardError.ReadToEndAsync()
    child.WaitForExit()

    { ExitCode = child.ExitCode
      StandardOutput = output.GetAwaiter().GetResult()
      StandardError = errors.GetAwaiter().GetResult() }

let runGh args =
    try
        runCommand "gh" args
    with :? Win32Exception as error when error.NativeErrorCode = 2 ->
        failwith "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."

let confirmOverwrite skill agent =
    if
        Console.IsInputRedirected
        || Console.IsOutputRedirected
        || Console.IsErrorRedirected
        || not (String.IsNullOrEmpty(Environment.GetEnvironmentVariable "GH_PROMPT_DISABLED"))
    then
        None
    else
        Console.Error.Write($"? Skill \"{skill.Name}\" from {skill.Repository} already exists for {agent}. Overwrite? [y/N] ")
        Console.Error.Flush()

        match Console.ReadLine() with
        | null -> Some false
        | answer -> Some(List.contains (answer.Trim().ToLowerInvariant()) [ "y"; "yes" ])

let private writeResult runtime result =
    let writeNonEmpty write (text: string) =
        if not (String.IsNullOrEmpty text) then
            write (text.TrimEnd('\r', '\n'))

    writeNonEmpty runtime.Write result.StandardOutput
    writeNonEmpty runtime.WriteError result.StandardError

let private needsOverwrite result =
    // gh has no structured conflict result; unknown failures stay fatal.
    result.ExitCode <> 0
    && result.StandardError.Contains("skills already installed:", StringComparison.Ordinal)
    && result.StandardError.Contains("(use --force to overwrite)", StringComparison.Ordinal)

let private skillCount count =
    if count = 1 then "1 skill" else $"{count} skills"

let install runtime options (skills: Skill list) =
    if not options.WhatIf then
        if List.isEmpty skills then
            runtime.Write "No skills to install."
        else
            runtime.Write($"Installing {skillCount skills.Length} for Copilot and OpenCode (user scope).")
            runtime.WriteError "Warning: Skills are not verified by GitHub and may contain prompt injections, hidden instructions, or malicious scripts. Always review skill contents before use."
            runtime.Write ""

    let mutable installed = 0
    let mutable skippedInstalls = 0

    for skill in skills do
        let skipped = ResizeArray<string>()

        for agent, label in [ "github-copilot", "Copilot"; "opencode", "OpenCode" ] do
            let args =
                [ "skill"; "install"; skill.Repository; skill.Name; "--agent"; agent; "--scope"; "user" ]
                @ (if options.Force then [ "--force" ] else [])

            if options.WhatIf then
                runtime.Write ("What if: gh " + String.concat " " args)
            else
                let run args =
                    if options.Verbose then
                        runtime.Write ("gh " + String.concat " " args)

                    let result = runtime.Gh args

                    if options.Verbose then
                        writeResult runtime result

                    result

                let result = run args

                let outcome =
                    if not options.Force && needsOverwrite result then
                        match runtime.ConfirmOverwrite skill label with
                        | Some true -> Some(run (args @ [ "--force" ]))
                        | Some false -> None
                        | None -> Some result
                    else
                        Some result

                match outcome with
                | None ->
                    skipped.Add label
                    skippedInstalls <- skippedInstalls + 1
                | Some result when result.ExitCode <> 0 ->
                    if not options.Verbose then
                        writeResult runtime result

                    failwithf
                        "Failed to install %s/%s for %s (user scope) (gh exited with %d)."
                        skill.Repository
                        skill.Name
                        agent
                        result.ExitCode
                | Some _ -> ()

        if not options.WhatIf then
            if skipped.Count = 0 then
                installed <- installed + 1
                runtime.Write($"✓ {skill.Name}")
            else
                runtime.Write(sprintf "- %s (skipped for %s)" skill.Name (String.concat ", " skipped))

    if not options.WhatIf && not (List.isEmpty skills) then
        runtime.Write ""

        if skippedInstalls = 0 then
            runtime.Write($"Installed {skillCount installed} for both agents.")
        else
            let skippedCount =
                if skippedInstalls = 1 then "1 agent install" else $"{skippedInstalls} agent installs"

            runtime.Write($"Installed {installed} of {skillCount skills.Length} for both agents; skipped {skippedCount}.")
