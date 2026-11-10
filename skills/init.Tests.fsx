#r "nuget: YamlDotNet, 18.1.0"
#load "SkillInstaller.fs"

open System
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

// Mock gh so tests never download skills or modify user configuration.
let fixture code =
    let calls = ResizeArray<string list>()
    let output = ResizeArray<string>()

    let gh args =
        calls.Add args
        code

    gh, calls, output

let skills =
    File.ReadAllText(Path.Combine(__SOURCE_DIRECTORY__, "skills.yml"))
    |> parseManifest

let defaults = { Force = false; WhatIf = false }

let tests =
    [ "installs manifest skills for both agents, with and without --force",
      fun () ->
          for force in [ false; true ] do
              let gh, calls, output = fixture 0
              install gh output.Add { defaults with Force = force } skills

              let expected =
                  [ for skill in skills do
                        for agent in [ "github-copilot"; "opencode" ] do
                            [ "skill"; "install"; skill.Repository; skill.Name; "--agent"; agent; "--scope"; "user" ]
                            @ (if force then [ "--force" ] else []) ]

              equal expected (Seq.toList calls)
              equal 0 output.Count

      "--what-if previews every install without invoking gh, even with --force",
      fun () ->
          for force in [ false; true ] do
              let gh, calls, output = fixture 0
              install gh output.Add { Force = force; WhatIf = true } skills
              equal 0 calls.Count
              equal (skills.Length * 2) output.Count

              for line in output do
                  equal true (line.StartsWith "What if: gh skill install ")
                  equal force (line.EndsWith " --force")

      "stops immediately and reports failed installs",
      fun () ->
          let gh, calls, output = fixture 17
          let first = List.head skills

          throwsContaining
              $"Failed to install {first.Repository}/{first.Name} for github-copilot (user scope) (gh exited with 17)."
              (fun () -> install gh output.Add defaults skills)

          equal 1 calls.Count

      "explains the prerequisite when gh is missing",
      fun () ->
          let previousPath = Environment.GetEnvironmentVariable "PATH"

          try
              Environment.SetEnvironmentVariable("PATH", "")

              throwsContaining
                  "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."
                  (fun () -> install runGh ignore defaults skills)
          finally
              Environment.SetEnvironmentVariable("PATH", previousPath)

      "parses options in either order",
      fun () ->
          equal (Some defaults) (parseArgs [||])
          equal (Some { defaults with Force = true }) (parseArgs [| "--force" |])
          equal (Some { defaults with WhatIf = true }) (parseArgs [| "--what-if" |])

          for args in [ [| "--force"; "--what-if" |]; [| "--what-if"; "--force" |] ] do
              equal (Some { Force = true; WhatIf = true }) (parseArgs args)

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
          let gh, calls, output = fixture 0
          install gh output.Add defaults (parseManifest "[]")
          equal 0 calls.Count

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
              let gh, calls, output = fixture 0
              throwsContaining "" (fun () -> parseManifest yaml |> install gh output.Add defaults)
              equal 0 calls.Count ]

for name, test in tests do
    test ()
    printfn "PASS %s" name

printfn "%d tests passed." tests.Length
