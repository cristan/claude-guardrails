# claude-guardrails

A global `CLAUDE.md` for [Claude Code](https://claude.com/claude-code) that codifies a set of opinionated rules I want applied to every project — git workflow, scope discipline, test data discipline, code quality, and a few more.

## Why
A memory won't cut it: I use many projects where the same learnings applies. And telling Claude over and over again to not be dumb a specific way definitely isn't my definition of fun.

## What's in it

- Every line of code must have real, verifiable purpose. This also means that test data has to be real. This makes claude less dumb, but also prevents it from hallucinating both the code and and the test data, resulting in meaningless code.
- Write much better comments. Without these instructions it writes more like off topic changelogs than proper docs.
- Functional code: when possible, make methods have no side effects. This makes them clean, clear and easily unit testable. For example: pass `now` as a parameter for methods who use the current date. This makes it unit testable without mocking anything.
- Git workflow: I do the commits, but the AI can suggest commit messages. Split up the work in small but meaningful commits. This way, you'll have a good portion to review and you can course correct early when it's still small, rather than having to review a massive commit where you have no idea whether it's good or not.

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
