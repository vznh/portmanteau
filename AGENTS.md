# AGENTS.md

Working agreement for AI assistants and human contributors on this repo. Read before making changes.

## Repo

`Portmanteau` is a macOS 14+ menu-bar app (Swift 6, SwiftUI) that strips tracking parameters from URLs on copy. The GitHub repo is `vznh/portmanteau`. Open source.

## Build & test

```
swift build
swift test
swift run Portmanteau
```

Open `Package.swift` in Xcode for SwiftUI Previews and the debugger.

## Author identity

Use `Jason Son <jvson@ucsc.edu>` for commits. Verify with `git config user.email` before committing.

## Style

Code should read like it was written in 2003: boring control flow, concrete types, no framework magic without reason.

### Naming

- **Short.** `auth` over `authToken` over `userAuthenticationToken`. Lean on scope and types to disambiguate.
- **Modifier-first.** `newStartThreshold`, not `newThresholdAfterStart`. General to specific.
- **No type suffixes.** `users`, not `usersList` or `usersArray`. The type is already in the type system.
- **Short ≠ abbreviated.** `auth` ✓; `athTok` ✗. A smart reader unfamiliar with the codebase should be able to guess what it means *in context*.

### Single-use variables

Inline them, unless the inlined expression is unreadably long or the name carries meaning the expression doesn't.

### Comments

- One short top-line on each function/type saying what it does, in as few words as possible.
- Inside large functions, terse phase markers only (`// validate`, `// emit`).
- **Never** restate what the code says. No `// increment counter` above `i++`.
- Comments are for *why* (constraints, invariants, surprises), not *what*.
- No emojis. No section banners (`// ===== Init =====`).

### Control flow

- Plain `for in` over `.map().filter().reduce()` chains. Chains are concise but force the reader to simulate multiple passes.
- `guard` early returns at the top, then linear flow top-to-bottom. No `return` buried inside nested ifs.
- Readable one-liners are fine. Cleverness for its own sake is not — if a one-liner takes longer to read than the equivalent four lines, expand it.

### Data

- Structs with fields beat classes that mutate hidden state. Data you can `print` is data you can debug.
- `switch` > dict-of-closures > class hierarchy. Use the simplest one that works.

### Abstraction

- **Composability over layering.** Small pure functions that snap together beat class hierarchies and factories.
- Free functions over methods/extensions when the function doesn't need private state. `sanitize(url)` over `url.sanitized()`.
- Plain types until proven otherwise. `String` over `URLString`. Generics and protocols earn their place; they don't get it for free.
- Add a protocol only when **two real implementations exist today**. Never for "future flexibility."
- Three similar lines beats a premature helper.
- No fluent builders or method chains returning `self`.

### Framework restraint

- Don't reach for `@StateObject`, `@Published`, `@Environment` for things that don't need view observation. They're opaque to anyone who hasn't memorized SwiftUI internals.
- No Combine pipelines when a function call works.
- Synchronous by default. Add `async` only where blocking actually happens. Don't infect the call stack out of habit.
- For early-stage code, `print()` beats wiring up a logger framework.

### Error handling

- Don't catch what can't throw. Don't null-check a non-nullable. Validate only at user/external boundaries.
- Fix root causes. `if x == nil { return }` to silence a crash is not a fix.
- `throws` over `Result<T, E>` for single-step errors. Result types stack into ugly chains; `try/catch` has been universally understood for decades.

### Organization

- Modify existing files when possible. New files only with a clear reason.
- Match the style of nearby code over generic "best practices."
- ~30 lines is a soft ceiling for functions. Beyond that, add phase comments or extract a helper — but don't extract a single-use helper just for size, the reader now has to jump around for nothing.

## Anti-patterns to refuse

- "Bonus" features beyond what was asked
- Refactors bundled with bugfixes
- Removing failing tests instead of fixing them
- Skipping hooks (`--no-verify`) or signing
- Force-pushing to `master`

## Commits & PRs

- One logical change per commit. Imperative mood: `Add X`, `Fix Y`.
- PR descriptions: what changed and why. Skip enumerating the diff — the diff says that.
- Don't add `Co-Authored-By: Claude` or similar trailers. Submitter is the author of record.

## CI & pre-commit

Aspirational — to wire up:

- GitHub Actions: `swift build` + `swift test` on push and PR
- Pre-commit hook: SwiftFormat + SwiftLint

## On AI assistance

This repo is developed with AI assistance. The rules above exist *because* they are the modes AI gravitates toward — following them matters more, not less, when AI is involved. They apply equally to human and AI-assisted contributions.

The submitter is the author of record. AI assistance should not appear in commit metadata.
