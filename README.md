# pyro-claude-utils

Claude Code role configurations for iOS development teams. Deploy role-specific `CLAUDE.md` files into any sibling repo.

## Roles

| Role | File | Description |
|------|------|-------------|
| iOS Developer | `roles/ios-developer.md` | Staff-level iOS engineer for features and bugfixes |
| QA Engineer | `roles/qa-engineer.md` | Quality assurance and testing strategy |
| Product Owner | `roles/product-owner.md` | Requirements, prioritisation, and acceptance criteria |
| Test Engineer | `roles/test-engineer.md` | Unit tests, mocks, and test architecture |

## Usage

### Deploy a role to a repo

```bash
# Deploy the iOS developer role to PyroFoundation
./deploy.sh ios-developer ../PyroFoundation

# Deploy the QA role to PyroAppStore
./deploy.sh qa-engineer ../PyroAppStore

# Deploy the test engineer role to PyroLogger
./deploy.sh test-engineer ../PyroLogger
```

### Refresh all deployed repos

```bash
# Re-deploy to all repos that already have a managed CLAUDE.md
./deploy.sh --refresh
```

### Remove a deployed config

```bash
./deploy.sh --remove ../PyroFoundation
```

### List available roles

```bash
./deploy.sh --list
```

## How it works

1. Each role in `roles/` defines Claude's persona, expertise, and working style.
2. The base template in `templates/base.md` provides shared iOS project conventions.
3. `deploy.sh` combines the base template + chosen role into a `CLAUDE.md` and copies it to the target repo.
4. A `.claude-role` marker file is placed in deployed repos to track which role is active and enable `--refresh`.

## Customisation

- Edit `templates/base.md` to change shared iOS conventions applied to all roles.
- Edit individual `roles/*.md` to tune a specific persona.
- Add new roles by creating a new markdown file in `roles/`.
