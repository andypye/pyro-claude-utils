#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW="$ROOT_DIR/workflows/fix-bug.md"

# --- Defaults ---
REPO=""
DESC=""
DESC_FILE=""
ISSUE_URL=""
ROLE="ios-developer"
AUTO=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Run a structured bug-fix workflow using Claude Code.

Options:
  -r, --repo <path>       Target repository (required)
  -d, --desc <text>       Bug description
  -f, --file <path>       Read bug description from a file
  -i, --issue <url>       GitHub issue URL (fetched via gh)
      --role <name>       Claude role to deploy (default: ios-developer)
      --auto              Run in non-interactive mode (claude -p)
  -h, --help              Show this help

Examples:
  $(basename "$0") -r ../PyroFoundation -d "Login screen crashes on nil user"
  $(basename "$0") -r ../PyroFoundation -f bug-report.md
  $(basename "$0") -r ../PyroFoundation -i https://github.com/org/repo/issues/42
EOF
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--repo)  REPO="$2"; shift 2 ;;
        -d|--desc)  DESC="$2"; shift 2 ;;
        -f|--file)  DESC_FILE="$2"; shift 2 ;;
        -i|--issue) ISSUE_URL="$2"; shift 2 ;;
        --role)     ROLE="$2"; shift 2 ;;
        --auto)     AUTO=true; shift ;;
        -h|--help)  usage; exit 0 ;;
        *)          echo "Unknown option: $1"; usage; exit 1 ;;
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

# --- Build description ---
if [[ -n "$ISSUE_URL" ]]; then
    echo "Fetching issue from GitHub..."
    DESC="$(gh issue view "$ISSUE_URL" --json title,body,labels,comments --jq '
        "# \(.title)\n\n\(.body)\n\n## Labels\n\(.labels | map(.name) | join(", "))\n\n## Comments\n\(.comments | map("**\(.author.login)**: \(.body)") | join("\n\n"))"
    ' 2>/dev/null)" || {
        echo "Error: could not fetch issue. Is gh installed and authenticated?"
        exit 1
    }
elif [[ -n "$DESC_FILE" ]]; then
    DESC="$(cat "$DESC_FILE")" || {
        echo "Error: could not read file '$DESC_FILE'"
        exit 1
    }
elif [[ -z "$DESC" ]]; then
    echo "Error: provide a bug description via --desc, --file, or --issue"
    usage
    exit 1
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

## Bug Description

$DESC
EOF
)"

# --- Launch Claude ---
echo "Starting bug-fix workflow in $REPO..."
echo "---"

cd "$REPO"

if [[ "$AUTO" == true ]]; then
    claude -p "$PROMPT"
else
    claude "$PROMPT"
fi
