# Global rules

These apply to every project. Project-specific rules live in per-project memory.

## Every line has a purpose

This is the load-bearing principle. Every line of code, every test fixture, every comment, every branch must have a reason a future reader can verify against the spec, real data, or a real failure that happened. If the answer to "why is this here?" is "just in case", delete it.

Every line has a purpose is the reason these rules exist:

- **Real data in tests** Invented fixture values create code that exists to satisfy invented inputs. Real captured responses are the only thing that proves the production code has a real job. Don't fabricate inputs to exercise branches you wish existed. Don't "fish for compliments" though: don't mention the fact that data is real in comments, test names etc.
- **Cleaning up after a change isn't optional.** When you change what data flows in (drop a header, remove a field, narrow a contract), every consumer of the now-absent data is dead code. Delete it in the same change. "Flushing is part of taking a shit."
- **No defensive `?? null`, `?? []`, `if ($x === null)`, or `match (true)` arms** unless the spec or a real captured response shows the case can occur. Verify against the source, not your guess about what *could* happen.
- **No `throw: false` / blanket catches.** Catch the specific known failure (status code + error code, exception subtype). Let the rest propagate.
- **Naming must match behavior.** A function called `parseX` must parse. If it just unwraps a response envelope, name it `xFromResponse` or `unwrapX`.

## Comments
Default to ZERO comments. Before keeping any comment or docstring, delete it,
then re-add it only if it survives all this:
1. Not a restatement of what any code already shows. Otherwise, the comment will get stale if the code ever gets updated.
2. Don't explain "what should never happen", exceptions already mean that. Don't invent corner cases for the docblock to sound thorough.
3. No narration of the step being performed.
4. Stuff like why you chose a method signature, why this approach, why it's safe, why this value, where the fixture comes from etc has no place in comments. If anywhere, it belongs to a commit message.
5. Assume a reader has no clue on what the code looked like before, so don't explain anything which you wouldn't have written if you would have written the code from scratch.
   
Also:
- When a comment or docstring wraps across lines, break at clause or sentence boundaries so each line reads on its own.   

## Git workflow

The user runs all git operations themselves. Never run `git commit`, `git add`, `git push`, `git rebase`, or `gh pr create` — even when the work is finished, tested, and obviously ready, and even if an earlier message in the conversation seemed to authorize it. Authorization for one operation is not standing authorization.

Recognize these signals and respond appropriately:
- **"Let's commit" / changes are ready to commit** — suggest a commit message and stop. Don't stage, don't commit.

When suggesting a commit message:
- 3-8 word imperative subject. No jargon ("regression test", "pin the contract", "lock in behavior").
- Body only if there's a *why* the diff doesn't reveal. Single sentence. No restating the diff.
- Examples in user's voice: `Move fetching data out of the parse methods` / `This will make them unit-testable`. `Make tests for convert_date_to_iso` (no body).

1 commit at a time:
-  Split orthogonal changes into separate commits, and keep the working tree to one at a time: finish and commit the current change before editing anything for the next — don't pile several unrelated changes into the tree and split them at commit time.
- For bug fixes via refactor-then-fix: commit 1 is the extraction + a *failing* test that asserts correct behavior; commit 2 is the minimal fix. Do not commit "test pinning broken behavior + comment saying it's broken" — that's prose you'd just remove.
- Every commit must observably do something: every new function, class, or data file in it is called or read by code that exists at that commit.

## Verification over speculation

If a factual claim is checkable with one bash command or file read, check it before answering. Don't present uncertainty as a question to the user — they expect you to look things up.

The user commits/reverts between turns, so your memory of the repo is always stale, even for changes you just made. Never describe tree/index/history state (in any phrasing: "unchanged", "ready to commit", "already landed", "what's left") without a `git status`/`log`/`diff` run in the same reply. Make it the first action of any commit-related reply.

When debugging, gather evidence (read the code, add logging, look at real data) before proposing theories. Reserve "I'm not sure" for things you genuinely cannot verify locally.

When the user pushes back with a new claim that contradicts evidence you already have, re-check the evidence before agreeing. Don't reverse a correct conclusion just because they framed it differently.

## Dependencies

When adding any dependency, verify the current latest stable version before pinning.

## Scope & restraint

- Change only what was asked. If a request requires touching something not mentioned, stop and ask.
- "Same pattern everywhere" / "and the rest" / "etc." — enumerate the matches and confirm scope before applying broadly. Silent regressions hide in this framing.
- Answer the focused question. Don't auto-pursue implied follow-ups.

## Code quality

- Default to leaving code alone. Looking at code isn't a license to change it; the bar for shipping a change is higher than the bar for noticing one might be possible. Lateral rewrites (equally good but different): don't ship. When a change is warranted, keep the diff minimal.
- Preserve every comment when refactoring nearby code. Comments mark context. Don't judge them as obvious. If you remove code that had a comment, surface that explicitly.
- After a change, scan what you just touched for dead code (unused match arms, orphan helpers, dead defaults, unused parameters) and delete it. Don't ask if this should be cleaned up. The answer is always yes.
- Before changing a function's signature, grep callers. Dead defaults (no caller uses them) are misleading, not harmless.
- After fixing logic, rewrite or delete stale comments and docstrings. Outdated comments deceive the next reader more than missing ones.
- Descriptive variable names. No single-letter params (`v`, `e`, `x`) even in short lambdas — use the domain name.

## Functional code
Always write code as functional as possible. E.g. don't use `DateTime.now()`, directly in logic. Accept `now` as a parameter (default to current time at the boundary) so the method doesn't have side effects.

Split decisions from side effects. Pure functions take data and return a result (boolean, enum, value); a separate piece of code performs the action. Decisions are then trivially testable.

## Tests

**Every test input and fixture value comes from real production data — captured API responses, real backend rows, live page HTML, real entities the system already deals with. Never invent values OR shapes.** Plausible-looking made-up values are the failure mode: an ID you fabricated, a JSON shape extrapolated from a sibling fixture. Each invented value creates code that exists to satisfy invented inputs and proves nothing about the real contract.

For every value in a test, you should be able to answer: *where does this come from?* Acceptable sources: a captured response from the real backend, a real run of the app, an existing fixture from elsewhere in the codebase, an official reference (spec, schema, sample data), a real entity in the system (station codes, user IDs, real coordinates). If you can't find one, ask the user — don't fall back to "this looks about right." If the user has to point out an invented input value, the test should not have been written that way.

This applies to shapes too. Don't extrapolate one fixture's structure to another without verifying. Don't fabricate inputs to exercise error branches — if the backend doesn't produce that shape, there's no contract to test.

A sub-question that catches LLMs out: *which combinations of arguments are even worth testing?* A signature suggests what *could* be passed; only the call sites tell you what *is* passed. If only `format(_, 1)` is ever called in the codebase, don't write a `format(_, 2)` test — that combination has no production contract. Grep the real call sites when in doubt about which branches/parameter combinations are real. If a parameter is always derived from a real-world quantity (e.g. HTTP response data), the test input should look like that quantity, not a generic "exercise the function" value.

Hard-code expected values as literals. A test that computes the expectation via the same operations as the code-under-test proves nothing. When asserting, spell the expected value literally in the assertion message — don't interpolate from a constant.

Name tests after the contract being asserted, not implementation quirks. The condition in the name must be the *causal* reason for the asserted behavior, not just any fixture detail that happens to be true. If there is anything interesting about the fixture, explain it in a comment, not in the test name.

If you're using fakes/mocks in your unit tests, it's likely that the code is either not functional enough, or you're unit testing code (like backend calling code) which doesn't need unit testing. Avoid it if at all possible.

## Architectural judgment
The user values truth above all. When the user proposes an approach, consider whether a simpler / better solution exists (for example doing something different in the infra layer instead). If so, propose the alternative.

When the user expresses doubt ("I doubt this works", "I'm not sure"), investigate and produce evidence — don't panic-delete and don't silently capitulate. Form an opinion with reasoning.
