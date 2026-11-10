#requires -Version 7.0
param(
  [Parameter(Mandatory, Position = 0)][ValidateSet('wait', 'comments')][string]$Mode,
  [Parameter(Mandatory, Position = 1)][ValidatePattern('^[^/]+/[^/]+$')][string]$Repository,
  [Parameter(Mandatory, Position = 2)][ValidateRange(1, 2147483647)][int]$Number
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

function Invoke-GhJson([string[]]$Arguments) {
  $output = & gh @Arguments
  if ($LASTEXITCODE -ne 0) { throw "gh failed (exit $LASTEXITCODE); no complete snapshot available." }
  ($output -join "`n") | ConvertFrom-Json -AsHashtable
}

function Wait-Copilot {
  $head = Invoke-GhJson @('pr', 'view', "$Number", '--repo', $Repository, '--json', 'headRefOid,headRefName')
  $sha = $head.headRefOid
  $branches = @($head.headRefName, "refs/pull/$Number/head")
  $deadline = (Get-Date).AddSeconds(30)
  while ($true) {
    $pages = @(Invoke-GhJson @('api', '--paginate', '--slurp', "repos/$Repository/actions/runs?head_sha=$sha&per_page=100"))
    $runs = @($pages.workflow_runs | Where-Object {
      $_.path -like '*copilot-pull-request-reviewer*' -and $_.head_sha -eq $sha -and
      ($_.head_branch -in $branches -or $Number -in $_.pull_requests.number)
    })
    if ($runs.Count) { break }
    $remaining = ($deadline - (Get-Date)).TotalSeconds
    if ($remaining -le 0) {
      "No Copilot action found for $Repository#$Number at $sha in 30s."
      return
    }
    Start-Sleep -Seconds ([Math]::Min(5, $remaining))
  }
  $failed = $false
  foreach ($run in $runs) {
    & gh run watch ([string]$run.id) --repo $Repository --exit-status --interval 5
    if ($LASTEXITCODE -ne 0) { $failed = $true }
  }
  if ($failed) { throw 'Copilot action watch failed; investigate before finishing.' }
}

function Get-Connection([string]$Field, [string]$Fields, [string]$After = '') {
  "${Field}(first: 100$After) { pageInfo { hasNextPage endCursor } nodes { $Fields } }"
}

function Complete-Connection($Node, [string]$Kind, $Fields) {
  foreach ($field in $Fields.Keys) {
    $value = $Node[$field]
    while ($value.pageInfo.hasNextPage) {
      $query = 'query($id: ID!, $cursor: String!) { node(id: $id) { ... on TYPE { CONNECTION } } }'
      $query = $query.Replace('TYPE', $Kind).Replace('CONNECTION',
        (Get-Connection $field $Fields[$field] ', after: $cursor'))
      $result = Invoke-GhJson @('api', 'graphql', '-f', "query=$query", '-f', "id=$($Node.id)",
        '-f', "cursor=$($value.pageInfo.endCursor)")
      $page = $result.data.node[$field]
      $value.nodes = @($value.nodes) + @($page.nodes)
      $value.pageInfo = $page.pageInfo
    }
  }
}

if ($Mode -eq 'wait') {
  Wait-Copilot
} else {
  $owner, $name = $Repository.Split('/')
  $comment = 'id author { login } body url createdAt updatedAt'
  $inline = "$comment databaseId replyTo { id }"
  $fields = [ordered]@{
    comments = $comment
    reviews = "$comment state submittedAt commit { oid }"
    reviewThreads = 'id path line originalLine isResolved isOutdated ' + (Get-Connection 'comments' $inline)
  }
  $query = @'
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      id number url state headRefOid
      CONNECTIONS
    }
  }
}
'@
  $selections = foreach ($field in $fields.Keys) { Get-Connection $field $fields[$field] }
  $query = $query.Replace('CONNECTIONS', ($selections -join "`n"))
  $result = Invoke-GhJson @('api', 'graphql', '-f', "query=$query", '-f', "owner=$owner",
    '-f', "name=$name", '-F', "number=$Number")
  $pr = $result.data.repository.pullRequest
  if ($null -eq $pr) { throw 'PR not found.' }
  Complete-Connection $pr 'PullRequest' $fields
  foreach ($thread in $pr.reviewThreads.nodes) {
    Complete-Connection $thread 'PullRequestReviewThread' @{ comments = $inline }
  }
  # Never emit a partial snapshot: all connections must finish first.
  $pr | ConvertTo-Json -Depth 100
}
