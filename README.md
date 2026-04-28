# claude-guardrails

A global `CLAUDE.md` for [Claude Code](https://claude.com/claude-code) that codifies a set of opinionated rules I want applied to every project — git workflow, scope discipline, test data discipline, code quality, and a few more.

## Why

Claude Code reads `~/.claude/CLAUDE.md` automatically on every session, in every repo. That file is the natural place to put rules you don't want to re-state in conversation. Without them, a fresh Claude will happily commit on your behalf, invent test fixtures, make lateral refactors, and panic-delete code when you express doubt. With them, it doesn't.

I got tired of writing the same feedback into project-level memory over and over. This is the consolidation.

## What's in it

- Git workflow — never commit, push, or open PRs on the user's behalf. Recognizes the difference between "PR time" (audit the branch), "let's commit" (suggest a message), and "commit it for me" (actually run it).
- Verification over speculation — if it's checkable in one command, check it before answering.
- Scope & restraint — change only what was asked; enumerate "etc." patterns before applying broadly.
- Code quality — minimal diffs, preserve comments, delete dead code without asking, descriptive names.
- Test data — real production data only. Never invent values or shapes. Hard-code expected values.
- Determinism — accept `now` as a parameter; split decisions from side effects.
- Surrounding context — read callers and config sources before changing a function.
- Architectural judgment — propose simpler solutions at a different layer when applicable; don't capitulate when the user expresses doubt.

See [CLAUDE.md](./CLAUDE.md) for the full text.

## Install

Option 1: symlink. Edits in the repo immediately apply to Claude Code:

```bash
git clone https://github.com/<you>/<repo-name>.git ~/Repos/<repo-name>
ln -s ~/Repos/<repo-name>/CLAUDE.md ~/.claude/CLAUDE.md
```

If `~/.claude/CLAUDE.md` already exists, back it up first: `mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak`.

Option 2: copy. If you'd rather edit a local copy and only sync deliberately:

```bash
curl -o ~/.claude/CLAUDE.md https://raw.githubusercontent.com/<you>/<repo-name>/main/CLAUDE.md
```

## Adapt it

Most of these rules are widely applicable, but a few reflect personal preference (e.g. how I want commit messages worded). Fork it, edit it, throw out anything you disagree with. The structure is meant to be readable enough that you can spot the parts you want to change.

If you have rules of your own that have saved you from a recurring AI failure, PRs welcome.
