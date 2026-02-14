#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW="$ROOT_DIR/workflows/code-review.md"

# --- Defaults ---
REPO=""
BRANCH=""
PR_NUM=""
ROLE="qa-engineer"
AUTO=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Run a structured code review workflow using Claude Code.

Options:
  -r, --repo <path>       Target repository (required)
  -b, --branch <name>     Review a branch (compared to main/master)
  -p, --pr <number>       Review a GitHub PR by number
      --role <name>       Claude role to deploy (default: qa-engineer)
      --auto              Run in non-interactive mode (claude -p)
  -h, --help              Show this help

If no --branch or --pr is given, reviews uncommitted changes.

Examples:
  # Review uncommitted changes
  $(basename "$0") -r ../PyroFoundation

  # Review a feature branch
  $(basename "$0") -r ../PyroFoundation -b feature/login-redesign

  # Review a GitHub PR
  $(basename "$0") -r ../PyroFoundation -p 42
EOF
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo)    REPO="$2"; shift 2 ;;
        -b|--branch)  BRANCH="$2"; shift 2 ;;
        -p|--pr)      PR_NUM="$2"; shift 2 ;;
        --role)       ROLE="$2"; shift 2 ;;
        --auto)       AUTO=true; shift ;;
        -h|--help)    usage; exit 0 ;;
        *)            echo "Unknown option: $1"; usage; exit 1 ;;
    esac
done

# --- Validate ---
if [[ -z "$REPO" ]]; then
    echo "Error: --repo is required"
    usage
    exit 1
fi

REPO="$(cd "$REPO" 2>/dev/null && pwd)" || {
    echo "Error: repository '$REPO' does not exist"
    exit 1
}

# --- Determine review target ---
if [[ -n "$PR_NUM" ]]; then
    REVIEW_TARGET="Review GitHub PR #$PR_NUM. Use \`gh pr view $PR_NUM\` and \`gh pr diff $PR_NUM\` to get the PR details and diff."
elif [[ -n "$BRANCH" ]]; then
    # Detect default branch
    DEFAULT_BRANCH="$(cd "$REPO" && git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")"
    REVIEW_TARGET="Review branch \`$BRANCH\` compared to \`$DEFAULT_BRANCH\`. Use \`git diff $DEFAULT_BRANCH...$BRANCH\` to see the changes and \`git log $DEFAULT_BRANCH...$BRANCH --oneline\` to see the commits."
else
    REVIEW_TARGET="Review all uncommitted changes (staged and unstaged). Use \`git diff\` and \`git diff --cached\` to see the changes."
fi

# --- Deploy role ---
if [[ -n "$ROLE" ]]; then
    echo "Deploying role '$ROLE' to $(basename "$REPO")..."
    "$ROOT_DIR/deploy.sh" "$ROLE" "$REPO"
    echo ""
fi

# --- Build prompt ---
WORKFLOW_TEXT="$(cat "$WORKFLOW")"

PROMPT="$(cat <<EOF
$WORKFLOW_TEXT

---

## Review Target

$REVIEW_TARGET
EOF
)"

# --- Launch Claude ---
echo "Starting code review in $REPO..."
echo "---"

cd "$REPO"

if [[ "$AUTO" == true ]]; then
    claude -p "$PROMPT"
else
    claude "$PROMPT"
fi
