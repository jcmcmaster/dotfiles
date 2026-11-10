#r "nuget: YamlDotNet, 18.1.0"
#load "SkillInstaller.fs"

open System.IO
open SkillInstaller

try
    match parseArgs (fsi.CommandLineArgs |> Array.tail) with
    | None -> printfn "%s" usage
    | Some options ->
        let runtime =
            { Gh = runGh
              Write = printfn "%s"
              WriteError = eprintfn "%s"
              ConfirmOverwrite = confirmOverwrite }

        File.ReadAllText(Path.Combine(__SOURCE_DIRECTORY__, "skills.yml"))
        |> parseManifest
        |> install runtime options
with error ->
    eprintfn "%s" error.Message
    exit 1
