#!/usr/bin/env bash
set -euo pipefail

# Post-push PR verification script.
#
# Waits for CI checks and Copilot code review to complete, then reports
# unresolved review threads on the PR (up to 100 threads inspected).
#
# Requires: gh CLI (authenticated)

export GH_PAGER=cat

COPILOT_REVIEW_WORKFLOW="Copilot code review"
DEFAULT_COPILOT_TIMEOUT=300
DEFAULT_CI_TIMEOUT=600
POLL_INTERVAL=15
THREAD_PROPAGATION_DELAY=15

SCRIPT_NAME="$(basename "$0")"

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME <PR_NUMBER> [options]

Waits for CI checks and Copilot code review, then reports unresolved threads.

Options:
  --timeout <seconds>     Max time to wait for Copilot review (default: $DEFAULT_COPILOT_TIMEOUT)
  --ci-timeout <seconds>  Max time to wait for CI checks (default: $DEFAULT_CI_TIMEOUT)
  -h, --help              Show this help

Exit codes:
  0  All clear — checks passed, no unresolved review threads
  1  Unresolved review threads found (details printed to stdout)
  2  CI checks failed or timed out
  3  Failed to query review threads (API/auth error)
EOF
}

# ── Argument parsing ────────────────────────────────────────────────

PR_NUMBER=""
COPILOT_TIMEOUT="$DEFAULT_COPILOT_TIMEOUT"
CI_TIMEOUT="$DEFAULT_CI_TIMEOUT"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --timeout)
            [[ $# -ge 2 ]] || { echo "Error: --timeout requires a value" >&2; exit 1; }
            COPILOT_TIMEOUT="$2"
            [[ "$COPILOT_TIMEOUT" =~ ^[0-9]+$ ]] || { echo "Error: --timeout must be a number" >&2; exit 1; }
            shift 2
            ;;
        --ci-timeout)
            [[ $# -ge 2 ]] || { echo "Error: --ci-timeout requires a value" >&2; exit 1; }
            CI_TIMEOUT="$2"
            [[ "$CI_TIMEOUT" =~ ^[0-9]+$ ]] || { echo "Error: --ci-timeout must be a number" >&2; exit 1; }
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            if [[ -z "$PR_NUMBER" ]]; then
                PR_NUMBER="$1"
            else
                echo "Error: unexpected argument: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z "$PR_NUMBER" ]]; then
    echo "Error: PR number is required." >&2
    usage >&2
    exit 1
fi

if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Error: PR number must be a positive integer, got: $PR_NUMBER" >&2
    exit 1
fi

# ── Detect repository and validate PR ───────────────────────────────

REPO_NWO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
OWNER="${REPO_NWO%%/*}"
REPO="${REPO_NWO##*/}"

if ! HEAD_SHA=$(gh pr view "$PR_NUMBER" --json headRefOid -q .headRefOid 2>&1); then
    echo "Error: could not find PR #${PR_NUMBER} in ${REPO_NWO}" >&2
    echo "$HEAD_SHA" >&2
    exit 1
fi

echo "=== Post-push PR verification: ${REPO_NWO}#${PR_NUMBER} ==="
echo ""

# ── Step 1: Wait for CI checks ──────────────────────────────────────

echo "--- Step 1: Waiting for CI checks (timeout: ${CI_TIMEOUT}s) ---"
set +e
if command -v timeout &>/dev/null; then
    timeout "$CI_TIMEOUT" gh pr checks "$PR_NUMBER" --watch 2>&1
    CI_EXIT=$?
else
    echo "⚠️  'timeout' command not found; CI wait has no timeout." >&2
    gh pr checks "$PR_NUMBER" --watch 2>&1
    CI_EXIT=$?
fi
set -e

if [[ $CI_EXIT -eq 124 ]]; then
    echo ""
    echo "❌ CI checks did not complete within ${CI_TIMEOUT}s."
    exit 2
elif [[ $CI_EXIT -ne 0 ]]; then
    echo ""
    echo "❌ One or more CI checks failed."
    exit 2
fi
echo ""
echo "✅ CI checks passed."
echo ""

# ── Step 2: Wait for Copilot code review ────────────────────────────

echo "--- Step 2: Waiting for Copilot code review (timeout: ${COPILOT_TIMEOUT}s) ---"
echo "PR head SHA: ${HEAD_SHA:0:12}"

ELAPSED=0
COPILOT_DONE=false

while [[ $ELAPSED -lt $COPILOT_TIMEOUT ]]; do
    MATCH=$(gh run list \
        -w "$COPILOT_REVIEW_WORKFLOW" \
        --json databaseId,headSha,status,conclusion \
        -L 50 \
        --jq '.[] | select(.headSha == "'"$HEAD_SHA"'") | "\(.databaseId)\t\(.status)\t\(.conclusion // "pending")"' \
        2>&1 | head -1 || true)

    if [[ -n "$MATCH" && ! "$MATCH" == *$'\t'* ]]; then
        echo "⚠️  gh run list: $MATCH" >&2
        MATCH=""
    fi

    if [[ -n "$MATCH" ]]; then
        IFS=$'\t' read -r RUN_ID STATUS CONCLUSION <<< "$MATCH"

        if [[ "$STATUS" == "completed" ]]; then
            if [[ "$CONCLUSION" == "success" ]]; then
                echo "✅ Copilot code review completed (run ${RUN_ID})."
            else
                echo "⚠️  Copilot code review completed with conclusion: ${CONCLUSION} (run ${RUN_ID})."
            fi
            COPILOT_DONE=true
            break
        fi
        echo "⏳ Copilot code review in progress (run ${RUN_ID}, status: ${STATUS})... [${ELAPSED}s/${COPILOT_TIMEOUT}s]"
    else
        echo "⏳ Waiting for Copilot code review to start... [${ELAPSED}s/${COPILOT_TIMEOUT}s]"
    fi

    sleep "$POLL_INTERVAL"
    ELAPSED=$((ELAPSED + POLL_INTERVAL))
done

if [[ "$COPILOT_DONE" != "true" ]]; then
    echo "⚠️  Copilot review did not complete within ${COPILOT_TIMEOUT}s. Checking threads anyway."
else
    echo "Waiting ${THREAD_PROPAGATION_DELAY}s for review threads to propagate..."
    sleep "$THREAD_PROPAGATION_DELAY"
fi
echo ""

# ── Step 3: Check unresolved review threads ──────────────────────────

echo "--- Step 3: Checking unresolved review threads ---"

REVIEW_THREADS_QUERY='query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 5) {
            nodes {
              body
              author { login }
            }
          }
        }
      }
    }
  }
}'

set +e
THREADS_OUTPUT=$(gh api graphql \
    -f query="$REVIEW_THREADS_QUERY" \
    -f owner="$OWNER" \
    -f name="$REPO" \
    -F number="$PR_NUMBER" \
    --jq '
        [.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)]
        | if length == 0 then "NONE"
          else
            ( map(
                "Thread \(.id) by @\(.comments.nodes[0].author.login)"
                + (if .path then " (\(.path):\(.line // "?"))" else "" end)
                + ":\n  \(.comments.nodes[0].body | split("\n")[0])"
              ) | join("\n\n") )
            + "\n\nTotal: \(length) unresolved thread(s)"
          end
    ')
GQL_EXIT=$?
set -e

if [[ $GQL_EXIT -ne 0 ]]; then
    echo "❌ Failed to query review threads." >&2
    [[ -n "$THREADS_OUTPUT" ]] && echo "$THREADS_OUTPUT" >&2
    exit 3
fi

if [[ "$THREADS_OUTPUT" == "NONE" ]]; then
    echo "✅ No unresolved review threads."
    echo ""
    echo "=== PR #${PR_NUMBER} is clean ==="
    exit 0
else
    printf '%s\n' "$THREADS_OUTPUT"
    echo ""
    echo "=== PR #${PR_NUMBER} has unresolved review threads ==="
    exit 1
fi
