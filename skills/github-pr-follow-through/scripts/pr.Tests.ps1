#requires -Version 7.0
# Run directly with pwsh -NoProfile -File; no Pester dependency.
$ErrorActionPreference = 'Stop'
$target = Join-Path $PSScriptRoot 'pr.ps1'

function Assert($Condition, [string]$Message = 'Assertion failed') {
  if (-not $Condition) { throw $Message }
}

function Reset-Fixture {
  $global:PrFixture = @{
    Responses = [Collections.Generic.Queue[object]]::new()
    Calls = [Collections.Generic.List[object]]::new()
    WatchCodes = [Collections.Generic.Queue[int]]::new()
    Now = [datetime]'2026-01-01'
    Fallback = $null
  }
  $global:LASTEXITCODE = 0
}

function gh {
  $global:PrFixture.Calls.Add(@($args))
  $global:LASTEXITCODE = 0
  if ($args[0] -eq 'run') {
    if ($global:PrFixture.WatchCodes.Count) {
      $global:LASTEXITCODE = $global:PrFixture.WatchCodes.Dequeue()
    }
    return
  }
  $response = if ($global:PrFixture.Responses.Count) {
    $global:PrFixture.Responses.Dequeue()
  } elseif ($null -ne $global:PrFixture.Fallback) {
    $global:PrFixture.Fallback
  } else { throw "Unexpected gh call: $args" }
  if ($response -is [Exception]) { $global:LASTEXITCODE = 1; return }
  ConvertTo-Json -InputObject $response -Depth 100 -Compress
}

function Get-Date { $global:PrFixture.Now }
function Start-Sleep([double]$Seconds) {
  $global:PrFixture.Now = $global:PrFixture.Now.AddSeconds($Seconds)
}

function New-Run([int]$Id = 1) {
  @{ id = $Id; path = 'dynamic/agents/copilot-pull-request-reviewer'
     head_sha = 'current'; head_branch = 'feature'; pull_requests = @() }
}

function New-Snapshot {
  $snapshot = @{ id = 'PR' }
  foreach ($field in @('comments', 'reviews', 'reviewThreads')) {
    $snapshot[$field] = @{ nodes = @(); pageInfo = @{ hasNextPage = $false } }
  }
  $snapshot
}

function Add-Snapshot($Snapshot) {
  $global:PrFixture.Responses.Enqueue(@{ data = @{ repository = @{ pullRequest = $Snapshot } } })
}

$tests = [ordered]@{
  'absence polls for thirty seconds' = {
    $global:PrFixture.Responses.Enqueue(@{ headRefOid = 'current'; headRefName = 'feature' })
    $global:PrFixture.Fallback = @{ workflow_runs = @() }
    $output = & $target wait owner/repo 7
    Assert ($output -match 'No Copilot action')
    Assert ($global:PrFixture.Now -eq [datetime]'2026-01-01T00:00:30')
    Assert ($global:PrFixture.Calls.Count -eq 8) 'Expected metadata plus seven polls'
  }
  'delayed action is detected' = {
    $global:PrFixture.Responses.Enqueue(@{ headRefOid = 'current'; headRefName = 'feature' })
    $global:PrFixture.Responses.Enqueue(@{ workflow_runs = @() })
    $global:PrFixture.Responses.Enqueue(@{ workflow_runs = @((New-Run)) })
    $null = & $target wait owner/repo 7
    Assert ($global:PrFixture.Now -eq [datetime]'2026-01-01T00:00:05')
    Assert (($global:PrFixture.Calls[-1] -join ' ') -eq 'run watch 1 --repo owner/repo --exit-status --interval 5')
  }
  'filters SHA, path, branch and supports paginated legacy/linked runs' = {
    $global:PrFixture.Responses.Enqueue(@{ headRefOid = 'current'; headRefName = 'feature' })
    $old = New-Run 1; $old.head_sha = 'old'
    $other = New-Run 2; $other.path = 'ci.yml'
    $branch = New-Run 3; $branch.head_branch = 'other'
    $legacy = New-Run 4; $legacy.head_branch = 'refs/pull/7/head'
    $legacy.path = 'dynamic/copilot-pull-request-reviewer/copilot-pull-request-reviewer'
    $linked = New-Run 5; $linked.head_branch = 'other'; $linked.pull_requests = @(@{ number = 7 })
    $global:PrFixture.Responses.Enqueue(@(
      @{ workflow_runs = @($old, $other, $branch) }, @{ workflow_runs = @($legacy, $linked) }))
    $null = & $target wait owner/repo 7
    $watches = @($global:PrFixture.Calls | Where-Object { $_[0] -eq 'run' })
    Assert ($watches.Count -eq 2)
    Assert ($watches[0][2] -eq '4' -and $watches[1][2] -eq '5')
  }
  'waits for all runs despite failure' = {
    $global:PrFixture.Responses.Enqueue(@{ headRefOid = 'current'; headRefName = 'feature' })
    $global:PrFixture.Responses.Enqueue(@{ workflow_runs = @((New-Run 1), (New-Run 2)) })
    $global:PrFixture.WatchCodes.Enqueue(1); $global:PrFixture.WatchCodes.Enqueue(0)
    $failed = $false
    try { & $target wait owner/repo 7 } catch { $failed = $true }
    Assert $failed
    Assert (@($global:PrFixture.Calls | Where-Object { $_[0] -eq 'run' }).Count -eq 2)
  }
  'API failures are not absence' = {
    $global:PrFixture.Responses.Enqueue(@{ headRefOid = 'current'; headRefName = 'feature' })
    $global:PrFixture.Responses.Enqueue([InvalidOperationException]::new('API failure'))
    $failed = $false
    try { & $target wait owner/repo 7 } catch { $failed = $true }
    Assert $failed
    Assert ($global:PrFixture.Now -eq [datetime]'2026-01-01')
  }
  'small snapshots use one GraphQL call' = {
    Add-Snapshot (New-Snapshot)
    $snapshot = (& $target comments owner/repo 7) | ConvertFrom-Json -AsHashtable
    Assert ($snapshot.id -eq 'PR')
    Assert ($global:PrFixture.Calls.Count -eq 1)
    Assert ($global:PrFixture.Calls[0][0] -eq 'api' -and $global:PrFixture.Calls[0][1] -eq 'graphql')
  }
  'paginates every outer connection' = {
    foreach ($field in @('comments', 'reviews', 'reviewThreads')) {
      Reset-Fixture
      $snapshot = New-Snapshot
      $snapshot[$field].pageInfo = @{ hasNextPage = $true; endCursor = 'next' }
      $item = @{ id = 'new' }
      if ($field -eq 'reviewThreads') { $item.comments = @{ nodes = @(); pageInfo = @{ hasNextPage = $false } } }
      $page = @{ nodes = @($item); pageInfo = @{ hasNextPage = $false } }
      Add-Snapshot $snapshot
      $global:PrFixture.Responses.Enqueue(@{ data = @{ node = @{ $field = $page } } })
      $result = (& $target comments owner/repo 7) | ConvertFrom-Json -AsHashtable
      Assert ($result[$field].nodes[0].id -eq 'new')
      Assert ($global:PrFixture.Calls.Count -eq 2)
      Assert ('cursor=next' -in $global:PrFixture.Calls[-1])
    }
  }
  'paginates replies inside a thread' = {
    $snapshot = New-Snapshot
    $snapshot.reviewThreads.nodes = @(@{ id = 'THREAD'; comments = @{
      nodes = @(@{ id = 'one' }); pageInfo = @{ hasNextPage = $true; endCursor = 'reply' } } })
    Add-Snapshot $snapshot
    $global:PrFixture.Responses.Enqueue(@{ data = @{ node = @{ comments = @{
      nodes = @(@{ id = 'two' }); pageInfo = @{ hasNextPage = $false } } } } })
    $result = (& $target comments owner/repo 7) | ConvertFrom-Json -AsHashtable
    Assert (($result.reviewThreads.nodes[0].comments.nodes.id -join ',') -eq 'one,two')
    Assert ('id=THREAD' -in $global:PrFixture.Calls[-1])
    Assert ($global:PrFixture.Calls[-1][3] -match 'PullRequestReviewThread')
  }
  'follows multiple pages' = {
    $snapshot = New-Snapshot
    $snapshot.comments.pageInfo = @{ hasNextPage = $true; endCursor = 'first' }
    Add-Snapshot $snapshot
    foreach ($index in 1, 2) {
      $global:PrFixture.Responses.Enqueue(@{ data = @{ node = @{ comments = @{
        nodes = @(@{ id = "$index" }); pageInfo = @{ hasNextPage = ($index -eq 1); endCursor = 'second' } } } } })
    }
    $result = (& $target comments owner/repo 7) | ConvertFrom-Json -AsHashtable
    Assert ($global:PrFixture.Calls.Count -eq 3)
    Assert ('cursor=second' -in $global:PrFixture.Calls[-1])
    Assert ($result.comments.nodes.Count -eq 2)
  }
  'pagination failure emits no partial snapshot' = {
    $snapshot = New-Snapshot
    $snapshot.comments.pageInfo = @{ hasNextPage = $true; endCursor = 'next' }
    Add-Snapshot $snapshot
    $global:PrFixture.Responses.Enqueue([InvalidOperationException]::new('API failure'))
    $output = [Collections.Generic.List[object]]::new()
    $failed = $false
    try { & $target comments owner/repo 7 | ForEach-Object { $output.Add($_) } } catch { $failed = $true }
    Assert $failed
    Assert ($output.Count -eq 0)
  }
  'missing PR fails' = {
    Add-Snapshot $null
    $failed = $false
    try { & $target comments owner/repo 7 } catch { $failed = $true }
    Assert $failed
  }
}

foreach ($test in $tests.GetEnumerator()) {
  Reset-Fixture
  & $test.Value
  Write-Host "PASS $($test.Key)"
}
Write-Host "$($tests.Count) tests passed."
