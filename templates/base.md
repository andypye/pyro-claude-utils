# Project Conventions

## iOS / Swift Standards

- Target the latest stable Xcode and Swift version unless the project specifies otherwise.
- Follow Apple's Swift API Design Guidelines for naming.
- Prefer value types (structs, enums) over reference types unless identity semantics are needed.
- Use Swift concurrency (async/await, actors) over completion handlers and GCD where the project's minimum deployment target supports it.
- Respect the existing architecture in the repo (MVVM, TCA, VIPER, etc.) — do not introduce a new pattern without discussion.
- Keep SwiftUI views thin: extract logic into ViewModels or dedicated types.
- Use `@MainActor` where UI state is mutated.
- Prefer protocol-oriented design for testability and dependency injection.

## Code Style

- No force-unwraps (`!`) outside of tests and IBOutlets.
- Prefer `guard` for early exits over nested `if let`.
- Use `// MARK: -` sections to organise files (Properties, Lifecycle, Public API, Private Helpers, etc.).
- Keep functions short and single-purpose.
- Naming: boolean properties/variables start with `is`, `has`, `should`, or `can`.

## Git & Workflow

- Commit messages: imperative mood, max 72 chars subject line.
- One logical change per commit.
- Do not commit commented-out code, debug prints, or TODOs without a ticket reference.

## Dependencies

- Check the project's `Package.swift` or Podfile/Cartfile before suggesting a new dependency.
- Prefer first-party Apple frameworks over third-party when feasible.
