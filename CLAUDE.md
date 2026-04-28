# Global rules

These apply to every project. Project-specific rules live in per-project memory.

## Git workflow

The user runs all git operations themselves. Never run `git commit`, `git add` followed by `git commit`, `git push`, `git reset` (without explicit ask), `git rebase`, or `gh pr create` — even when the work is finished, tested, and obviously ready, and even if an earlier message in the conversation seemed to authorize it. Authorization for one operation is not standing authorization.

Recognize these signals and respond appropriately:
- **"PR time" / "doublecheck this branch"** — audit the full branch diff (`git diff main..HEAD`) for gotchas, run tests, summarize what's risky. No commit message — the commits already exist.
- **"Let's commit" / changes are ready to commit** — suggest a commit message and stop. Don't stage, don't commit.
- **"Commit it for me"** (unambiguous imperative) — only then do you run the commit.

When suggesting a commit message:
- 3-8 word imperative subject. No jargon ("regression test", "pin the contract", "lock in behavior").
- Body only if there's a *why* the diff doesn't reveal. Single sentence. No restating the diff.
- Examples in user's voice: `Move fetching data out of the parse methods` / `This will make them unit-testable`. `Make tests for convert_date_to_iso` (no body).

When structuring multi-part work:
- Split orthogonal changes into separate commits. Helper change + its tests is one commit; the parser rewrite that uses it is another.
- For bug fixes via refactor-then-fix: commit 1 is the extraction + a *failing* test that asserts correct behavior; commit 2 is the minimal fix. Do not commit "test pinning broken behavior + comment saying it's broken" — that's prose you'd just remove.

## Verification over speculation

If a factual claim is checkable with one bash command or file read, check it before answering. Don't present uncertainty as a question to the user — they expect you to look things up.

When debugging, gather evidence (read the code, add logging, look at real data) before proposing theories. Reserve "I'm not sure" for things you genuinely cannot verify locally.

When the user pushes back with a new claim that contradicts evidence you already have, re-check the evidence before agreeing. Don't reverse a correct conclusion just because they framed it differently.

## Scope & restraint

- Change only what was asked. If a request requires touching something not mentioned, stop and ask.
- "Same pattern everywhere" / "and the rest" / "etc." — enumerate the matches and confirm scope before applying broadly. Silent regressions hide in this framing.
- Stay inside the repo. Never scan `~`, `/Users`, or other broad paths — triggers TCC prompts and violates privacy. If you need a path outside the repo, the user names it.
- Answer the focused question. Don't auto-pursue implied follow-ups.
- Don't revisit code regions the user has explicitly closed.

## Code quality

- Keep diffs minimal. Lateral changes (equally good but different) don't ship — only changes that are clearly better.
- Preserve every comment when refactoring nearby code. Comments mark context. Don't judge them as obvious. If you remove code that had a comment, surface that explicitly.
- After a change, scan what you just touched for dead code (unused match arms, orphan helpers, dead defaults, unused parameters) and delete it. Don't ask. The answer is always yes.
- After fixing logic, rewrite or delete stale comments and docstrings. Outdated comments deceive the next reader more than missing ones.
- Descriptive variable names. No single-letter params (`v`, `e`, `x`) even in short lambdas — use the domain name.
- Before changing a function's signature, grep callers. Dead defaults (no caller uses them) are misleading, not harmless.

## Test data

Every test input and fixture value comes from real production data — captured API responses, real backend rows, live page HTML. Never invent values OR shapes. Don't extrapolate one fixture's structure to another without verifying. Don't fabricate inputs to exercise error branches — if the backend doesn't produce that shape, there's no contract to test.

Hard-code expected values as literals. A test that computes the expectation via the same operations as the code-under-test proves nothing. When asserting, spell the expected value literally in the assertion message — don't interpolate from a constant.

Name tests after the contract being asserted, not implementation quirks. Good: `test_parses_date_string_from_ports_victoria_page`. Bad: `test_expected_movement_format_with_double_space`.

## Determinism

Don't use `DateTime.now()`, `Date.now()`, `time.time()` etc. directly in logic. Accept `now` as a parameter (default to current time at the boundary). Tests that depend on real-world time drift past thresholds break unpredictably.

Split decisions from side effects. Pure functions take data and return a result (boolean, enum, value); a separate piece of code performs the action. Decisions are then trivially testable.

## Surrounding context

Before changing a function, read the callers, nearby variables, and any config it consumes (env vars, terraform, IAM policies, config files). When code reads from `os.environ` or a config source, inspect that source and explicitly state whether you updated it or verified it's already correct. The user shouldn't have to ask "did you update terraform?"

When searching for usage of something, search broadly (no language filter) — usages cross file types.

## Architectural judgment

When the user proposes an approach, consider whether a simpler solution lives at a different layer (queue retention setting, IAM policy, database constraint, infra config) before implementing the application-code version. If so, propose the alternative.

When the user expresses doubt ("I doubt this works", "I'm not sure"), investigate and produce evidence — don't panic-delete and don't silently capitulate. Form an opinion with reasoning.
