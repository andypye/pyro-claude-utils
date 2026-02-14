# Workflow: Code Review

You are performing a thorough code review. Be constructive, specific, and prioritised. Follow every step in order.

## Step 1 — Gather the Changes

Determine what to review:
- If a branch or diff range is specified below, use that.
- Otherwise, review uncommitted changes (`git diff` for unstaged, `git diff --cached` for staged).
- If there are no changes, ask the user what they want reviewed.

Read every changed file in full (not just the diff) to understand the context around the changes.

## Step 2 — Understand the Intent

- Read commit messages if available.
- Infer what the change is trying to accomplish.
- If the intent is unclear, ask the user before reviewing.

## Step 3 — Review for Correctness

For each file changed, check:
- Does the logic do what it's supposed to?
- Are there off-by-one errors, wrong comparisons, or incorrect conditions?
- Are optionals handled correctly (no unsafe force-unwraps, proper nil handling)?
- Are error cases handled? What happens when things fail?
- Are return values and state mutations correct?

## Step 4 — Review for Edge Cases and Robustness

- Empty/nil inputs
- Collections with 0, 1, or many items
- Network failures, timeouts, server errors
- Concurrent access / race conditions
- App lifecycle events (background, foreground, termination)
- Memory pressure / low disk space
- Device variations (iPhone, iPad, different iOS versions)

## Step 5 — Review for Security

- Data validation at system boundaries
- Sensitive data handling (keychain vs UserDefaults, logging PII)
- URL construction (injection risks)
- Certificate pinning / ATS configuration
- Proper use of authentication tokens

## Step 6 — Review for Performance

- Unnecessary work on the main thread
- N+1 query patterns or repeated expensive operations
- Large allocations in tight loops
- Missing caching where appropriate
- Image/asset loading efficiency

## Step 7 — Review for Code Quality

- Naming clarity and consistency
- Function length and complexity (suggest splitting if too long)
- Adherence to project conventions
- Proper use of access control (private, internal, public)
- Dead code, commented-out code, or debug artifacts
- Missing or misleading comments

## Step 8 — Review Test Coverage

- Are there tests for the new/changed code?
- Do tests cover error paths and edge cases?
- Are tests isolated and deterministic?
- Are mocks/stubs appropriate (not over-mocked)?
- Is the test naming descriptive?

## Step 9 — Present Findings

Organise findings by severity:

### Critical (must fix before merge)
Issues that would cause crashes, data loss, security vulnerabilities, or incorrect behaviour.

### Major (should fix before merge)
Bugs in edge cases, missing error handling, performance issues, missing tests for critical paths.

### Minor (nice to fix)
Style issues, naming improvements, minor simplifications, additional test coverage.

### Suggestions (optional improvements)
Refactoring ideas, alternative approaches, future considerations.

For each finding:
- **File and line**: exact location
- **Issue**: what's wrong
- **Why it matters**: impact
- **Suggested fix**: concrete code suggestion

## Step 10 — Offer to Fix

After presenting all findings, ask the user:

> "Would you like me to fix any of these issues? I can address:
> - All critical and major issues
> - Specific items you choose
> - All findings
>
> Which would you prefer?"

If the user wants fixes:
1. Create a new branch or continue on the current one (ask the user).
2. Fix each issue, committing separately with clear messages.
3. Run tests after all fixes.
4. Present a summary of what was fixed.
