#r "nuget: YamlDotNet, 18.1.0"
#load "SkillInstaller.fs"

open System
open System.Collections.Generic
open System.IO
open SkillInstaller

let equal expected actual =
    if expected <> actual then
        failwithf "Expected %A, got %A" expected actual

let throwsContaining (expected: string) action =
    let error =
        try
            action ()
            None
        with ex ->
            Some ex

    match error with
    | Some error when error.Message.Contains expected -> ()
    | _ -> failwithf "Expected an error containing %A, got %A" expected error

let success =
    { ExitCode = 0
      StandardOutput = "Installed upstream output\n"
      StandardError = "Using ref main\n(could not read directory)\n" }

let conflict =
    { ExitCode = 1
      StandardOutput = ""
      StandardError = "skills already installed: productivity/grilling (use --force to overwrite)\n" }

// Mock gh so installer tests never download skills or modify user configuration.
let fixture gh =
    let calls = ResizeArray<string list>()
    let output = ResizeArray<string>()
    let errors = ResizeArray<string>()

    let runtime =
        { Gh = fun args -> calls.Add args; gh args
          Write = output.Add
          WriteError = errors.Add
          ConfirmOverwrite = fun _ _ -> None }

    runtime, calls, output, errors

let sequence (results: CommandResult list) =
    let pending = Queue<CommandResult>(results)
    fixture (fun _ -> pending.Dequeue())

let skills =
    File.ReadAllText(Path.Combine(__SOURCE_DIRECTORY__, "skills.yml"))
    |> parseManifest

let defaults = { Force = false; WhatIf = false; Verbose = false }
let first = List.head skills

let failureMessage skill agent code =
    $"Failed to install {skill.Repository}/{skill.Name} for {agent} (user scope) (gh exited with {code})."

let tests =
    [ "installs manifest skills for both agents, with and without --force",
      fun () ->
          for force in [ false; true ] do
              let runtime, calls, output, errors = fixture (fun _ -> success)
              install runtime { defaults with Force = force } skills

              let expected =
                  [ for skill in skills do
                        for agent in [ "github-copilot"; "opencode" ] do
                            [ "skill"; "install"; skill.Repository; skill.Name; "--agent"; agent; "--scope"; "user" ]
                            @ (if force then [ "--force" ] else []) ]

              equal expected (Seq.toList calls)
              equal
                  ([ $"Installing {skills.Length} skills for Copilot and OpenCode (user scope)."; "" ]
                   @ (skills |> List.map (fun skill -> $"✓ {skill.Name}"))
                   @ [ ""; $"Installed {skills.Length} skills for both agents." ])
                  (Seq.toList output)

              equal 1 errors.Count
              equal true (errors[0].StartsWith "Warning: Skills are not verified by GitHub")
              equal true (errors[0].Contains "prompt injections, hidden instructions, or malicious scripts")

      "--what-if previews every install without invoking gh, even with --force",
      fun () ->
          for force, verbose in [ false, false; true, false; false, true; true, true ] do
              let runtime, calls, output, errors = fixture (fun _ -> failwith "Unexpected gh call")
              let runtime = { runtime with ConfirmOverwrite = fun _ _ -> failwith "Unexpected confirmation" }
              install runtime { Force = force; WhatIf = true; Verbose = verbose } skills
              equal 0 calls.Count
              equal (skills.Length * 2) output.Count
              equal 0 errors.Count

              for line in output do
                  equal true (line.StartsWith "What if: gh skill install ")
                  equal force (line.EndsWith " --force")

      "stops immediately and preserves failed stdout and stderr",
      fun () ->
          let failed = { ExitCode = 17; StandardOutput = "partial output\n"; StandardError = "permission denied\n" }
          let runtime, calls, output, errors = fixture (fun _ -> failed)

          throwsContaining
              (failureMessage first "github-copilot" 17)
              (fun () -> install runtime defaults skills)

          equal 1 calls.Count
          equal "partial output" output[output.Count - 1]
          equal "permission denied" errors[errors.Count - 1]
          equal false (output |> Seq.exists (fun line -> line.StartsWith "✓" || line.StartsWith "Installed "))

      "does not report success until both agents succeed",
      fun () ->
          let failed = { success with ExitCode = 23; StandardError = "OpenCode failed" }
          let runtime, calls, output, errors = sequence [ success; failed ]
          throwsContaining (failureMessage first "opencode" 23) (fun () -> install runtime defaults skills)
          equal 2 calls.Count
          equal false (output |> Seq.exists (fun line -> line.StartsWith "✓"))
          equal "OpenCode failed" errors[errors.Count - 1]

      "verbose shows every command and both captured streams",
      fun () ->
          let runtime, calls, output, errors = fixture (fun _ -> success)
          install runtime { defaults with Verbose = true } [ first ]
          equal 2 calls.Count
          equal 2 (output |> Seq.filter (fun line -> line.StartsWith "gh skill install ") |> Seq.length)
          equal 2 (output |> Seq.filter ((=) "Installed upstream output") |> Seq.length)
          equal [ "Using ref main\n(could not read directory)"; "Using ref main\n(could not read directory)" ] (errors |> Seq.skip 1 |> Seq.toList)
          equal "Installed 1 skill for both agents." output[output.Count - 1]

      "verbose failures do not print diagnostics twice",
      fun () ->
          let failed = { success with ExitCode = 17 }
          let runtime, _, output, errors = fixture (fun _ -> failed)
          throwsContaining "gh exited with 17" (fun () -> install runtime { defaults with Verbose = true } skills)
          equal 1 (output |> Seq.filter ((=) "Installed upstream output") |> Seq.length)
          equal 2 errors.Count

      "confirmed overwrites retry only that agent with --force",
      fun () ->
          let runtime, calls, output, errors = sequence [ conflict; success; success ]
          let prompts = ResizeArray<Skill * string>()
          let runtime =
              { runtime with
                  ConfirmOverwrite = fun skill agent -> prompts.Add(skill, agent); Some true }

          install runtime defaults [ first ]
          equal [ (first, "Copilot") ] (Seq.toList prompts)
          equal 3 calls.Count
          equal (calls[0] @ [ "--force" ]) calls[1]
          equal false (List.contains "--force" calls[0])
          equal false (List.contains "--force" calls[2])
          equal true (List.contains "opencode" calls[2])
          equal 1 errors.Count
          equal true (output |> Seq.contains $"✓ {first.Name}")

      "declined overwrites are skipped without claiming both agents installed",
      fun () ->
          for results, skipped, count in
              [ [ conflict; success ], "Copilot", 1
                [ success; conflict ], "OpenCode", 1
                [ conflict; conflict ], "Copilot, OpenCode", 2 ] do
              let runtime, calls, output, errors = sequence results
              let runtime = { runtime with ConfirmOverwrite = fun _ _ -> Some false }
              install runtime defaults [ first ]
              equal 2 calls.Count
              equal false (calls |> Seq.exists (List.contains "--force"))
              equal false (output |> Seq.exists (fun line -> line.StartsWith "✓"))
              equal true (output |> Seq.contains $"- {first.Name} (skipped for {skipped})")
              let skippedCount = if count = 1 then "1 agent install" else "2 agent installs"
              equal $"Installed 0 of 1 skill for both agents; skipped {skippedCount}." output[output.Count - 1]
              equal 1 errors.Count

      "non-interactive conflicts preserve diagnostics and never retry",
      fun () ->
          let runtime, calls, output, errors = fixture (fun _ -> conflict)
          throwsContaining (failureMessage first "github-copilot" 1) (fun () -> install runtime defaults skills)
          equal 1 calls.Count
          equal (conflict.StandardError.TrimEnd()) errors[errors.Count - 1]
          equal false (output |> Seq.exists (fun line -> line.StartsWith "✓"))

      "explicit --force never asks for confirmation or retries",
      fun () ->
          let runtime, calls, _, _ = fixture (fun _ -> conflict)
          let runtime = { runtime with ConfirmOverwrite = fun _ _ -> failwith "Unexpected confirmation" }
          throwsContaining "gh exited with 1" (fun () -> install runtime { defaults with Force = true } skills)
          equal 1 calls.Count
          equal true (List.contains "--force" calls[0])

      "honors GH_PROMPT_DISABLED without reading console input",
      fun () ->
          let previous = Environment.GetEnvironmentVariable "GH_PROMPT_DISABLED"

          try
              Environment.SetEnvironmentVariable("GH_PROMPT_DISABLED", "1")
              equal None (confirmOverwrite first "Copilot")
          finally
              Environment.SetEnvironmentVariable("GH_PROMPT_DISABLED", previous)

      "failed overwrite retries retain their own diagnostics",
      fun () ->
          let failed = { ExitCode = 9; StandardOutput = "retry output"; StandardError = "retry failed" }
          let runtime, calls, output, errors = sequence [ conflict; failed ]
          let runtime = { runtime with ConfirmOverwrite = fun _ _ -> Some true }
          throwsContaining (failureMessage first "github-copilot" 9) (fun () -> install runtime defaults skills)
          equal 2 calls.Count
          equal "retry output" output[output.Count - 1]
          equal "retry failed" errors[errors.Count - 1]
          equal 2 errors.Count

      "unrelated failures do not trigger overwrite confirmation",
      fun () ->
          let failed = { conflict with StandardError = "unsupported flag --force" }
          let runtime, calls, _, _ = fixture (fun _ -> failed)
          let runtime = { runtime with ConfirmOverwrite = fun _ _ -> failwith "Unexpected confirmation" }
          throwsContaining "gh exited with 1" (fun () -> install runtime defaults skills)
          equal 1 calls.Count

      "captures large child streams, exit status, and disables hidden prompts",
      fun () ->
          let directory = Path.Combine(Path.GetTempPath(), "skill installer tests " + Guid.NewGuid().ToString("N"))
          Directory.CreateDirectory directory |> ignore

          try
              let script = Path.Combine(directory, "child.fsx")
              File.WriteAllLines(
                  script,
                  [ "open System"
                    "Console.OutputEncoding <- Text.Encoding.UTF8"
                    "Console.Out.Write(\"✓ é\")"
                    "Console.Out.Write(String('o', 131072))"
                    "Console.Error.Write(\"✓ é\")"
                    "Console.Error.Write(String('e', 131072))"
                    "Console.Error.Write(\"|\" + Environment.GetEnvironmentVariable(\"GH_PROMPT_DISABLED\"))"
                    "Console.Error.Write(\"|\" + Console.In.ReadToEnd())"
                    "exit 17" ]
              )
              let result = runCommand "dotnet" [ "fsi"; script ]
              equal 17 result.ExitCode
              equal ("✓ é" + String('o', 131072)) result.StandardOutput
              equal ("✓ é" + String('e', 131072) + "|1|") result.StandardError
          finally
              Directory.Delete(directory, true)

      "explains the prerequisite when gh is missing",
      fun () ->
          let previousPath = Environment.GetEnvironmentVariable "PATH"

          try
              Environment.SetEnvironmentVariable("PATH", "")

              throwsContaining
                  "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."
                  (fun () -> runGh [ "skill"; "install" ] |> ignore)
          finally
              Environment.SetEnvironmentVariable("PATH", previousPath)

      "parses options in either order",
      fun () ->
          equal (Some defaults) (parseArgs [||])
          equal (Some { defaults with Force = true }) (parseArgs [| "--force" |])
          equal (Some { defaults with WhatIf = true }) (parseArgs [| "--what-if" |])
          equal (Some { defaults with Verbose = true }) (parseArgs [| "--verbose" |])

          for args in [ [| "--force"; "--what-if" |]; [| "--what-if"; "--force" |] ] do
              equal (Some { defaults with Force = true; WhatIf = true }) (parseArgs args)

          for args in
              [ [| "--force"; "--what-if"; "--verbose" |]
                [| "--verbose"; "--force"; "--what-if" |]
                [| "--what-if"; "--verbose"; "--force" |] ] do
              equal (Some { Force = true; WhatIf = true; Verbose = true }) (parseArgs args)

      "supports help and rejects unknown arguments",
      fun () ->
          equal None (parseArgs [| "--help" |])

          for args in [ [| "--oops" |]; [| "unexpected" |]; [| "--help"; "--force" |] ] do
              throwsContaining usage (fun () -> parseArgs args |> ignore)

      "parses YAML comments, quoted values and reordered fields",
      fun () ->
          equal
              [ { Repository = "owner/repo"; Name = "example" } ]
              (parseManifest "# Skills\n- skill: 'example'\n  repository: \"owner/repo\"\n")

      "accepts an empty skill list",
      fun () ->
          let runtime, calls, output, errors = fixture (fun _ -> failwith "Unexpected gh call")
          install runtime defaults (parseManifest "[]")
          equal 0 calls.Count
          equal [ "No skills to install." ] (Seq.toList output)
          equal 0 errors.Count

      "rejects missing, null and blank fields",
      fun () ->
          for yaml in
              [ "- repository: owner/repo"
                "- skill: example"
                "- repository: null\n  skill: example"
                "- repository: owner/repo\n  skill: ' '"
                "- null" ] do
              throwsContaining
                  "Each entry in skills.yml must specify repository and skill."
                  (fun () -> parseManifest yaml |> ignore)

      "rejects empty or malformed manifests before installing anything",
      fun () ->
          for yaml in [ ""; "repository: owner/repo"; "- example"; "- [unterminated" ] do
              let runtime, calls, _, _ = fixture (fun _ -> failwith "Unexpected gh call")
              throwsContaining "" (fun () -> parseManifest yaml |> install runtime defaults)
              equal 0 calls.Count ]

for name, test in tests do
    test ()
    printfn "PASS %s" name

printfn "%d tests passed." tests.Length
