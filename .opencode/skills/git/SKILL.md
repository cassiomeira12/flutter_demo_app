---
name: git
description: "Git version control and branching strategy. Use when: writing commit messages following Conventional Commits, reviewing branch naming, applying Git-flow branching strategy, resolving merge conflicts, writing .gitignore rules, rebasing or squashing commits, tagging releases, cherry-picking, or explaining Git internals (reflog, bisect, stash, worktrees)."
argument-hint: "Describe the Git operation or problem"
---

# Git

## When to Use

- Writing or validating Conventional Commit messages
- Creating or naming branches (feature, fix, chore, release)
- Applying Git-flow workflow (master, developments/master, feature/_, hotfix/_, release/\*)
- Resolving merge conflicts or rebase issues
- Reviewing or creating `.gitignore` files
- Tagging a release or explaining semantic versioning
- Recovering commits via `reflog`, bisecting bugs, using `git stash`

## Core Skills

- **Git fundamentals**: commit, branch, merge, rebase, cherry-pick, stash, tag, reflog
- **Git-flow**: branching model (master, developments/master, feature/_, release/_, hotfix/\*)
- **Conventional Commits**: structured commit messages for changelogs and automation

## Conventional Commits Format

**Every commit message MUST be prefixed with the current branch suffix.**

Format: `[<branch-suffix>] <type>: <description>`

The branch suffix is extracted from the branch name:

- `developments/master` → `[master]`
- `developments/firebase` → `[firebase]`
- `feature/auth-login` → `[auth-login]`
- `fix/crash-on-launch` → `[crash-on-launch]`
- `hotfix/memory-leak` → `[memory-leak]`

```
[<branch-suffix>] <type>: <short description>

[optional body]

[optional footer: BREAKING CHANGE: ..., Closes #issue]
```

| Type       | When                         |
| ---------- | ---------------------------- |
| `feat`     | New feature                  |
| `fix`      | Bug fix                      |
| `docs`     | Documentation only           |
| `style`    | Formatting, no logic change  |
| `refactor` | Refactor without feature/fix |
| `test`     | Adding or updating tests     |
| `chore`    | Build, CI, tooling changes   |
| `perf`     | Performance improvement      |
| `ci`       | CI/CD configuration          |

**Examples:**

```
[master] feat: add player strength rating field
[master] fix: correct undo stack on first move
[firebase] chore: bump AGP to 8.7.2
[auth-login] docs: add sequence diagram for balance feature
```

## Git-flow Branch Naming

| Branch  | Pattern                                     | Purpose               |
| ------- | ------------------------------------------- | --------------------- |
| Main    | `master`                                    | Production-ready code |
| Develop | `developments/master`                       | Integration branch    |
| Feature | `feature/<short-desc>`                      | New features          |
| Fix     | `fix/<short-desc>` or `hotfix/<short-desc>` | Bug fixes             |
| Release | `release/<version>`                         | Release preparation   |

## Useful Commands

```bash
# Interactive rebase (squash last N commits)
git rebase -i HEAD~N

# Find the commit that introduced a bug
git bisect start
git bisect bad          # current is broken
git bisect good <hash>  # known good commit

# Recover lost commit
git reflog
git checkout <hash>

# Clean working tree (dry run first!)
git clean -n   # preview
git clean -fd  # execute

# Partial staging
git add -p
```

## Anti-patterns to Flag

- Missing branch prefix: `feat(...)` instead of `[master] feat(...)`
- Generic commit messages: "fix bug", "update", "wip"
- Direct commits to `master`/`developments/master` without PR
- Long-lived feature branches (causes merge conflicts)
- Force-pushing to shared branches
- Mixing unrelated changes in a single commit

## Git Hooks

This project uses a `commit-msg` hook to enforce the commit message format.
The hook lives in `.githooks/commit-msg` and is installed via `make install-hooks` or manually:

```bash
git config core.hooksPath .githooks
```

The hook validates that the first line matches `[<suffix>] <type>: <description>`.
