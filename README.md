# pyro-claude-utils

Claude Code role configurations and workflow scripts for iOS development teams.

## Workflow Scripts

These scripts launch Claude Code with structured, step-by-step workflows. They deploy the appropriate role, build a prompt from the workflow template, and open an interactive Claude session in the target repo.

| Script | Purpose | Default Role |
|--------|---------|--------------|
| `scripts/fix-bug.sh` | Diagnose and fix a bug | ios-developer |
| `scripts/feature.sh` | Build a new feature | ios-developer |
| `scripts/feature.sh -e` | Enhance an existing feature | ios-developer |
| `scripts/code-review.sh` | Review changes and offer to fix issues | qa-engineer |

### Fix a bug

```bash
# From a description
./scripts/fix-bug.sh -r ../PyroFoundation -d "Login screen crashes on nil user"

# From a file
./scripts/fix-bug.sh -r ../PyroFoundation -f bug-report.md

# From a GitHub issue
./scripts/fix-bug.sh -r ../PyroFoundation -i https://github.com/org/repo/issues/42
```

### Build a new feature

```bash
./scripts/feature.sh -r ../PyroFoundation -d "Add biometric authentication to login"
```

### Enhance an existing feature

```bash
./scripts/feature.sh -r ../PyroFoundation -e -d "Add retry logic to network layer"
```

### Code review

```bash
# Review uncommitted changes
./scripts/code-review.sh -r ../PyroFoundation

# Review a feature branch
./scripts/code-review.sh -r ../PyroFoundation -b feature/login-redesign

# Review a GitHub PR
./scripts/code-review.sh -r ../PyroFoundation -p 42
```

### Common options

All scripts support:
- `--role <name>` — override the default Claude role (e.g. `--role test-engineer`)
- `--auto` — run in non-interactive mode (`claude -p`)
- `--help` — show full usage

## Roles

| Role | File | Description |
|------|------|-------------|
| iOS Developer | `roles/ios-developer.md` | Staff-level iOS engineer for features and bugfixes |
| QA Engineer | `roles/qa-engineer.md` | Quality assurance and testing strategy |
| Product Owner | `roles/product-owner.md` | Requirements, prioritisation, and acceptance criteria |
| Test Engineer | `roles/test-engineer.md` | Unit tests, mocks, and test architecture |

### Deploy a role manually

```bash
./deploy.sh ios-developer ../PyroFoundation
./deploy.sh --list
./deploy.sh --refresh
./deploy.sh --remove ../PyroFoundation
```

## How it works

1. Each role in `roles/` defines Claude's persona, expertise, and working style.
2. The base template in `templates/base.md` provides shared iOS project conventions.
3. Workflow prompts in `workflows/` define step-by-step processes (bug fix, develop, review).
4. The scripts in `scripts/` combine role + workflow + your description and launch Claude Code in the target repo.
5. `deploy.sh` manages `CLAUDE.md` deployment. A `.claude-role` marker tracks which role is active in each repo.

## Project structure

```
pyro-claude-utils/
├── deploy.sh                  # Deploy roles to repos
├── scripts/
│   ├── fix-bug.sh             # Bug fix workflow
│   ├── feature.sh             # Feature / enhancement workflow
│   └── code-review.sh         # Code review workflow
├── workflows/
│   ├── fix-bug.md             # Bug fix step-by-step instructions
│   ├── develop.md             # Feature development instructions
│   └── code-review.md         # Code review instructions
├── roles/
│   ├── ios-developer.md       # Staff iOS developer persona
│   ├── qa-engineer.md         # QA engineer persona
│   ├── product-owner.md       # Product owner persona
│   └── test-engineer.md       # Test engineer persona
└── templates/
    └── base.md                # Shared iOS/Swift conventions
```

## Customisation

- Edit `templates/base.md` to change shared iOS conventions applied to all roles.
- Edit individual `roles/*.md` to tune a specific persona.
- Edit `workflows/*.md` to adjust the step-by-step processes.
- Add new roles by creating a new markdown file in `roles/`.
