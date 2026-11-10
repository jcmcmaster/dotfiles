---
name: implement-reviewed-pr
description: Implement a saved plan end-to-end, conduct independent multi-perspective reviews with subagents, raise a PR, and handle Copilot PR review feedback.
---
Use this skill when the user asks to implement a plan and wants a high-confidence PR with review feedback handled.

Workflow:

1. Read the saved plan and current todo state before changing code.
2. Create a dedicated git worktree from `origin/main` and work only in that worktree.
3. Implement the plan in coherent slices, updating todo status as each slice starts and completes.
4. Keep the implementation balanced across:
   - simplicity
   - maintainability
   - idiomatic use of tech stack
   - consistency with existing conventions
   - security
   - correctness
5. Run relevant builds, tests, format checks, docs builds, and infrastructure validation.
6. Launch independent subagent reviews after implementation:
   - one review focused on simplicity
   - one review focused on idiomaticness and consistency
   - one review focused on security
   - one review focused on correctness
7. Determine a best solution given subagent review findings. Prompt user if path is unclear. Then, implement.
8. Create a focused conventional commit.
9. Push the branch and open a PR with a file-based PR body.
10. Wait for and handle all automated PR review comments:
    - fix the issue
    - commit and push
    - reply explaining the fix and referencing the commit
    - resolve review threads
11. Iterate until CI passes and review threads are resolved.

Do not merge the PR unless the user explicitly approves.
