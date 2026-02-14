# Workflow: Fix Bug

You are performing a structured bug fix. Follow every step in order. Do not skip steps. Be methodical and safe.

## Step 1 — Understand the Bug

Read the bug description below carefully. Identify:
- What the expected behaviour is.
- What the actual (broken) behaviour is.
- Any reproduction steps, environment details, or stack traces.

If the description is unclear, ask clarifying questions before proceeding.

## Step 2 — Explore the Codebase

- Find the code relevant to the bug. Search for related files, types, and functions.
- Read the relevant source files thoroughly. Understand the current logic before changing anything.
- Check if there are existing tests covering this area.

Summarise what you found: which files are involved and what the current code does.

## Step 3 — Identify the Root Cause

- Trace the code path that triggers the bug.
- Identify the root cause, not just the symptom.
- Explain the root cause clearly.

Present your diagnosis and proposed fix to the user. Wait for confirmation before proceeding.

## Step 4 — Create a Branch

Create a git branch for this fix:
```
git checkout -b fix/<short-description>
```

If the repo has uncommitted changes, warn the user and ask how to proceed.

## Step 5 — Implement the Fix

- Make the minimal change that fixes the root cause.
- Do not refactor unrelated code.
- Do not change formatting or style of surrounding code.
- Commit the fix with a clear message referencing the bug.

## Step 6 — Run Tests

Run the project's existing test suite:
- If tests pass, continue.
- If tests fail, determine if the failure is related to your change or pre-existing. Fix any failures your change introduced.

If you cannot determine how to run tests, ask the user.

## Step 7 — Write a Regression Test

- Write a test that would have caught this bug.
- The test should fail without your fix and pass with it.
- Follow the existing test patterns and naming conventions in the project.
- Commit the test separately from the fix.

If the bug is not practically testable (e.g., pure UI layout), explain why and skip this step.

## Step 8 — Self-Review

Review your own changes as if you were a senior code reviewer:

1. Run `git diff main...HEAD` (or the appropriate base branch) to see all changes.
2. Check for:
   - Correctness: does this actually fix the bug?
   - Side effects: could this break anything else?
   - Edge cases: does the fix handle nil, empty data, concurrent access?
   - Memory: any retain cycles or leaks introduced?
   - Thread safety: any main-thread violations?
3. If you find issues, fix them before proceeding.

## Step 9 — Summary

Present a summary:
- **Root cause**: what was wrong
- **Fix**: what you changed and why
- **Tests**: what test coverage was added
- **Files changed**: list of modified files
- **Remaining risks**: anything the user should manually verify

Do NOT push the branch. Leave that to the user.
