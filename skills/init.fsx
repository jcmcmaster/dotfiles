#r "nuget: YamlDotNet, 18.1.0"
#load "SkillInstaller.fs"

open System.IO
open SkillInstaller

try
    match parseArgs (fsi.CommandLineArgs |> Array.tail) with
    | None -> printfn "%s" usage
    | Some options ->
        File.ReadAllText(Path.Combine(__SOURCE_DIRECTORY__, "skills.yml"))
        |> parseManifest
        |> install runGh (printfn "%s") options
with error ->
    eprintfn "%s" error.Message
    exit 1
