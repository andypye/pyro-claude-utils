# Workflow: Develop Feature

You are performing a structured feature development workflow. Follow every step in order. Be methodical and safe.

## Step 1 — Understand the Requirements

Read the feature description below carefully. Identify:
- What the user wants built or changed.
- Acceptance criteria (explicit or implied).
- Any constraints or preferences mentioned.

If requirements are ambiguous, ask clarifying questions before proceeding.

## Step 2 — Explore the Codebase

- Search for code related to this feature area.
- Understand the existing architecture, patterns, and conventions.
- Identify where new code should live and what existing code it needs to integrate with.
- Check for related tests to understand the testing patterns used.

**If this is an enhancement to an existing feature:**
- Read the current implementation thoroughly.
- Understand the existing behaviour that must be preserved.
- Note the public API surface that other code may depend on.

Summarise what you found: relevant files, architecture, and how the new work fits in.

## Step 3 — Plan the Implementation

Present a clear implementation plan:
- List the files to create or modify.
- Describe the approach and key design decisions.
- Call out any trade-offs or alternatives you considered.
- Estimate the scope (small / medium / large).

Wait for the user to approve the plan before writing code.

## Step 4 — Create a Branch

Create a git branch:
```
git checkout -b feature/<short-description>
```

For enhancements, use:
```
git checkout -b enhance/<short-description>
```

If the repo has uncommitted changes, warn the user and ask how to proceed.

## Step 5 — Implement Incrementally

Build the feature in small, logical steps:

1. **For each increment:**
   - Write the code change.
   - Verify it compiles / builds.
   - Commit with a descriptive message.

2. **Guidelines:**
   - Follow the project's existing patterns and conventions.
   - Keep functions short and single-purpose.
   - Use dependency injection for testability.
   - Consider edge cases: nil, empty, errors, concurrency.
   - Do not introduce new dependencies without discussing first.

3. **After every 2-3 commits**, briefly check in with the user on progress.

## Step 6 — Write Tests

- Write unit tests for all new logic.
- Follow the project's existing test patterns.
- Cover: happy path, error cases, edge cases, boundary values.
- Use protocol-based mocks or closures for dependencies.
- Ensure tests are fast, isolated, and deterministic.
- Commit tests separately from implementation.

## Step 7 — Run All Tests

Run the full test suite:
- If all tests pass, continue.
- If tests fail, determine if failures are from your changes or pre-existing.
- Fix any failures your changes introduced before proceeding.

## Step 8 — Self-Review

Review your own changes as a senior code reviewer:

1. Run `git diff main...HEAD` (or appropriate base branch) to see all changes.
2. Check for:
   - **Correctness**: does this meet the requirements and acceptance criteria?
   - **Completeness**: are all cases handled? Any missing functionality?
   - **Edge cases**: nil, empty, large data, network failure, background/foreground?
   - **API design**: are public interfaces clear and consistent?
   - **Memory**: retain cycles, leaks, unnecessary strong references?
   - **Thread safety**: main-thread violations, race conditions?
   - **Accessibility**: VoiceOver labels, Dynamic Type support?
3. Fix any issues found before proceeding.

## Step 9 — Summary

Present a summary:
- **What was built**: brief description of the feature/enhancement
- **Key decisions**: architectural choices made and why
- **Tests**: what test coverage was added
- **Files changed**: list of created/modified files
- **Follow-up items**: anything that's out of scope but worth noting

Do NOT push the branch. Leave that to the user.
