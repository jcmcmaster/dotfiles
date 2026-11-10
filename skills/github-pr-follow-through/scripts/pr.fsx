#load "Pr.fs"

open System.Diagnostics
open System.Threading
open Pr

let gh output (args: string list) =
    let start =
        ProcessStartInfo("gh", UseShellExecute = false, RedirectStandardOutput = (output = Capture))

    args |> List.iter start.ArgumentList.Add
    use child = Process.Start start

    let text =
        if output = Capture then
            child.StandardOutput.ReadToEnd()
        else
            ""

    child.WaitForExit()
    child.ExitCode, text

let clock = Stopwatch.StartNew()

let runtime =
    { Gh = gh
      Elapsed = (fun () -> clock.Elapsed)
      Sleep = Thread.Sleep }

try
    // Nothing is emitted until the complete operation succeeds.
    execute runtime (fsi.CommandLineArgs |> Array.tail)
    |> Option.iter (printfn "%s")
with error ->
    eprintfn "%s" error.Message
    exit 1
