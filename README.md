# claude-guardrails

A global `CLAUDE.md` for [Claude Code](https://claude.com/claude-code) that codifies a set of opinionated rules I want applied to every project — git workflow, scope discipline, test data discipline, code quality, and a few more.

## Why

Claude Code reads `~/.claude/CLAUDE.md` automatically on every session, in every repo. That file is the natural place to put rules you don't want to re-state in conversation. Without them, a fresh Claude will happily commit on your behalf, invent test fixtures, make lateral refactors, and panic-delete code when you express doubt. With them, it doesn't.

I got tired of writing the same feedback into project-level memory over and over. This is the consolidation.

## What's in it

- Every line of code must have real, verifiable purpose. Hence real data in unit tests. No writing checks "just in case". Clean up dead code the second it is introduced. Claude still ended making up test data, hence a hook which adds a reminder. That finally seems to help.
- Functional code: when possible, make methods have no side effects. This makes them clean, clear and easily unit testable. For example: pass `now` as a parameter for methods who use the current date. This makes it unit testable without mocking anything.
- Git workflow: I do the commits, but the AI can suggest commit messages
- "PR time": whenever I type this, everything which is changed in the branch is doublechecked for gotcha's. This has saved me many, many times.
- Random stuff to not make AI dumb

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
