# Contributing to Coffee Call

Thank you for your interest in contributing to Coffee Call.

This document describes the development workflow, coding conventions, testing expectations, and contribution process used by the project.

For architectural decisions and layer responsibilities, see [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Development Requirements

Before contributing, make sure your environment meets the minimum requirements:

- macOS
- Xcode 15.0+
- Swift 5.9+
- iOS 13.0+

The project prioritizes native Apple technologies and currently avoids unnecessary third-party dependencies.

---

## Getting Started

Clone the repository:

```bash
git clone <repository-url>
```

Navigate to the project directory:

```bash
cd CoffeeCall
```

Open the Xcode project:

```bash
open CoffeeCall.xcodeproj
```

Before starting development, verify that the project builds successfully.

---

## Development Workflow

All changes should be developed in dedicated branches.

Avoid committing feature work directly to `main`.

The expected workflow is:

```text
main
  ↑
Pull Request
  ↑
feature branch
```

Keep branches focused on a single logical change whenever possible.

---

## Branch Naming

Use lowercase names with hyphen-separated descriptions.

### Features

```text
feat/login
feat/coffee-catalog
feat/cart-checkout
```

### Bug Fixes

```text
fix/onboarding-navigation
fix/cart-total-calculation
```

### Refactoring

```text
refactor/networking-layer
refactor/onboarding-view-model
```

### Tests

```text
test/onboarding-view-model
test/catalog-repository
```

### Chores

```text
chore/project-setup
chore/swiftlint
chore/ci
```

### Documentation

```text
docs/architecture
docs/contributing
```

Prefer concise branch names that clearly communicate intent.

---

## Commit Messages

Coffee Call follows the Conventional Commits convention.

Format:

```text
<type>(<scope>): <description>
```

Examples:

```text
feat(auth): implement login form validation
fix(onboarding): prevent navigation after final page
refactor(networking): extract request builder
test(onboarding): add welcome view model tests
docs(architecture): document dependency rules
chore(ci): add build workflow
```

Common commit types:

| Type | Purpose |
|---|---|
| `feat` | New functionality |
| `fix` | Bug fix |
| `refactor` | Internal code change without behavior change |
| `test` | Tests |
| `docs` | Documentation |
| `chore` | Tooling, configuration, or maintenance |
| `perf` | Performance improvement |
| `ci` | Continuous Integration changes |

Commit messages must:

- Be written in English
- Use imperative and concise language
- Describe one logical change
- Avoid unrelated modifications in the same commit

---

## Architecture

Coffee Call follows:

- Clean Architecture
- MVVM-C
- Dependency Injection
- Protocol-oriented abstractions
- Feature-oriented organization

Before introducing a new architectural abstraction, verify that it solves a concrete problem.

Do not introduce layers, protocols, factories, or shared components solely for future hypothetical use.

For the complete architecture guidelines, read:

```text
ARCHITECTURE.md
```

---

## UIKit Guidelines

Application screens are built using UIKit and programmatic View Code.

Do not use Storyboards or XIBs for application screens.

`LaunchScreen.storyboard` is reserved exclusively for the system launch screen.

Each screen should normally separate responsibilities into:

```text
XyzView.swift
XyzViewController.swift
XyzViewModel.swift
```

Navigation should be handled by a Coordinator.

Views must remain focused on presentation and layout.

ViewControllers must not contain business logic.

---

## Layout

Use native Auto Layout through `NSLayoutAnchor`.

Example:

```swift
NSLayoutConstraint.activate([
    titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
])
```

Third-party layout frameworks should not be introduced without a clear technical justification.

---

## Dependency Injection

Dependencies must be explicit.

Prefer initializer injection:

```swift
final class ExampleViewModel {

    private let repository: ExampleRepository

    init(repository: ExampleRepository) {
        self.repository = repository
    }
}
```

Factories may be introduced when object construction becomes complex.

Avoid:

- Service locators
- Global mutable dependencies
- Hidden dependencies
- Heavy DI containers

---

## Concurrency

Use Swift Structured Concurrency for asynchronous work.

Prefer:

```text
async
await
Task
```

Typical use cases include:

- Networking
- Repository operations
- File I/O
- Storage operations

Combine should be used primarily for reactive bindings between ViewModels and ViewControllers.

Do not use Combine as the default mechanism for business logic.

Avoid mixing Combine and async/await to solve the same responsibility.

---

## Code Style

Code should prioritize clarity over cleverness.

Follow these principles:

- SOLID
- Clean Code
- DRY when duplication represents the same knowledge
- Explicit dependencies
- Small and focused types
- Descriptive naming
- Single responsibility

Avoid premature abstractions.

A duplicated implementation may temporarily be preferable to an incorrect shared abstraction.

---

## Naming

Types should use descriptive names:

```swift
CoffeeRepository
FetchCoffeeCatalogUseCase
CoffeeListViewModel
CoffeeListViewController
```

Avoid vague names such as:

```text
Manager
Helper
Utils
Handler
Thing
DataObject
```

unless the responsibility is genuinely clear from context.

Protocols should describe capabilities or architectural roles rather than automatically adding suffixes without meaning.

Examples:

```swift
CoffeeRepository
NetworkService
TokenStorage
```

---

## File Organization

Files should live inside the feature or shared area that owns their responsibility.

Example:

```text
Features/
└── Authentication/
    ├── Presentation/
    ├── Domain/
    └── Data/
```

Do not move code into `Core` or `UIComponents` until it has a genuine shared use case.

Avoid creating empty folders for future functionality.

---

## Error Handling

Errors should be explicit and meaningful.

Infrastructure errors should be translated into higher-level errors when appropriate.

Avoid:

```swift
try?
```

when silently discarding the error would hide a meaningful failure.

Avoid generic errors when a domain-specific failure communicates intent more clearly.

Sensitive information must never appear in logs or error messages.

---

## Testing

Coffee Call uses XCTest.

Unit tests should prioritize:

- ViewModels
- Use Cases
- Repositories
- Services
- Mappers
- Business rules

Test naming follows:

```swift
func test_<givenCondition>_<whenAction>_<thenExpectation>()
```

Example:

```swift
func test_lastPage_whenNextIsRequested_thenFinishesOnboarding()
```

Mocks, spies, and fakes should remain simple and conform to the same protocols used by production code.

Avoid third-party mocking frameworks unless there is a demonstrated need.

Critical Domain and Data code should target at least 70% meaningful test coverage.

---

## Memory Management

Review closures and delegates for retain cycles.

Use weak captures when the closure should not own its captured object:

```swift
{ [weak self] in
    self?.handleEvent()
}
```

Delegates should normally be weak when ownership belongs elsewhere.

Memory-sensitive changes should be verified using Instruments when appropriate.

---

## Security

Never commit:

- Authentication tokens
- Passwords
- API secrets
- Private keys
- Sensitive customer information

Sensitive credentials must use secure storage such as Keychain.

Do not store secrets in `UserDefaults`.

Do not log sensitive information.

Remote communication must use HTTPS.

---

## Before Opening a Pull Request

Verify that:

- The project builds successfully
- Existing tests pass
- New behavior is covered by tests when appropriate
- No new warnings are introduced
- No secrets or sensitive information were committed
- Architecture conventions are respected
- Navigation remains Coordinator-driven
- Dependencies are explicitly injected
- Views contain no business logic
- The branch contains only changes related to its purpose

---

## Pull Requests

Pull Requests should be small enough to review effectively.

A Pull Request should explain:

- What changed
- Why the change was necessary
- How the change can be tested
- Any known limitation
- Any architectural decision that requires reviewer attention

UI changes should include screenshots or screen recordings whenever they improve review quality.

Avoid mixing unrelated refactors with feature development unless the refactor is required by the feature.

---

## Code Review

Reviews should focus on:

- Correctness
- Architecture
- Testability
- Readability
- Memory management
- Security
- Performance
- Accessibility when applicable

Feedback should address the code and technical decision, not the contributor.

---

## Definition of Done

A change is considered complete when:

- The expected behavior is implemented
- The code builds successfully
- Relevant tests pass
- Architecture rules are respected
- Dependencies remain explicit
- Error handling is appropriate
- No known retain cycle is introduced
- No sensitive information is exposed
- Documentation is updated when necessary
- The Pull Request is ready for review

---

## Questions and Architectural Changes

Significant architectural changes should be discussed before implementation.

When proposing a new dependency, framework, architectural layer, or shared abstraction, describe:

1. The problem being solved
2. Why the current architecture is insufficient
3. Alternatives considered
4. Trade-offs introduced
5. Impact on testing and maintainability

Coffee Call favors intentional evolution over unnecessary architectural complexity.
