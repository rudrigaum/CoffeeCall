
# Coffee Call Architecture

This document describes the architectural principles, boundaries, and development conventions adopted by Coffee Call.

The goal is to keep the codebase maintainable, testable, scalable, and prepared for future modularization without introducing unnecessary abstractions before they are needed.

---

## Architecture Overview

Coffee Call follows:

- Clean Architecture
- MVVM-C
- Dependency Injection
- Protocol-oriented abstractions
- Feature-oriented organization

The architecture separates application responsibilities into three conceptual layers:

```text
Presentation
     ↓
   Domain
     ↓
    Data
```

Dependencies must always point toward the business rules.

The Domain layer must not depend on Presentation or Data implementation details.

---

## Core Principles

The architecture is guided by the following principles:

- Explicit dependencies
- Separation of concerns
- Dependency inversion
- Testability
- Small and focused components
- Native Apple frameworks whenever appropriate
- Incremental architecture
- No premature abstraction

New architectural components should be introduced only when a concrete product requirement justifies them.

---

# Layers

## Presentation

The Presentation layer contains UI-related components and presentation state.

Typical components:

```text
Presentation/
├── Coordinator/
├── View/
├── ViewController/
└── ViewModel/
```

Responsibilities:

### View

A `UIView` subclass is responsible for:

- Creating UI components
- Configuring visual properties
- Defining layout constraints
- Exposing user interactions to the ViewController

Views must not:

- Execute business rules
- Perform navigation
- Access repositories
- Perform networking
- Persist data

Views should remain as passive as possible.

---

### ViewController

A `UIViewController` is responsible for:

- Managing the screen lifecycle
- Loading the custom View through `loadView()`
- Binding ViewModel state to the View
- Forwarding user interactions to the ViewModel
- Managing presentation-specific behavior

Example:

```swift
override func loadView() {
    view = contentView
}
```

ViewControllers must not:

- Contain business rules
- Perform networking directly
- Access storage directly
- Decide application navigation

Navigation belongs to Coordinators.

---

### ViewModel

The ViewModel is responsible for:

- Holding presentation state
- Transforming Domain information into UI state
- Processing presentation events
- Calling Use Cases
- Exposing observable state to the ViewController

Combine may be used for ViewModel-to-View bindings.

Example:

```swift
@Published private(set) var state: ViewState
```

Combine must not become the primary mechanism for business logic or infrastructure operations.

Asynchronous I/O should use Swift Structured Concurrency.

---

### Coordinator

Coordinators manage navigation and application flows.

Responsibilities:

- Creating ViewControllers
- Injecting dependencies
- Managing screen transitions
- Starting and finishing feature flows
- Managing child Coordinators when necessary

Example flow:

```text
AppCoordinator
       ↓
OnboardingCoordinator
       ↓
WelcomeViewController
```

A ViewController must never push, present, or instantiate the next business screen directly.

Navigation events should be communicated through delegates, closures, or navigation abstractions depending on the complexity of the flow.

---

# Domain

The Domain layer contains application business rules.

Typical structure:

```text
Domain/
├── Entities/
├── UseCases/
└── Repositories/
```

The Domain layer should remain independent from UIKit, networking implementations, storage implementations, and external frameworks.

---

## Entities

Entities represent core business concepts.

Examples that may appear as Coffee Call evolves:

```text
Coffee
CoffeeOrder
Cart
Customer
CoffeeSize
```

Entities should contain business-relevant data and behavior without UI or infrastructure dependencies.

---

## Use Cases

Use Cases represent application actions or business operations.

Examples:

```text
FetchCoffeeCatalogUseCase
AddCoffeeToCartUseCase
PlaceOrderUseCase
AuthenticateUserUseCase
```

A Use Case should represent one clear business intent.

Example conceptual dependency:

```text
ViewModel
    ↓
UseCase
    ↓
Repository Protocol
```

Use Cases must depend on repository abstractions rather than concrete implementations.

---

## Repository Abstractions

Repository protocols belong to the Domain layer because they describe what the business logic needs rather than how data is obtained.

Example:

```swift
protocol CoffeeRepository {
    func fetchCoffees() async throws -> [Coffee]
}
```

The Domain layer knows the protocol.

It does not know whether data comes from:

- REST API
- Local cache
- Database
- Mock
- File
- Another service

---

# Data

The Data layer implements infrastructure details.

Typical structure:

```text
Data/
├── DataSources/
├── Mappers/
├── Models/
└── Repositories/
```

Responsibilities include:

- Network requests
- Persistence
- DTO decoding
- Mapping external data into Domain entities
- Implementing Domain repository protocols

---

## Data Sources

Data Sources communicate with concrete data providers.

Examples:

```text
CoffeeRemoteDataSource
CoffeeLocalDataSource
AuthenticationRemoteDataSource
```

A Data Source should focus on retrieving or storing data, not on application business rules.

---

## Models

Data models represent external or persistence formats.

Examples:

```text
CoffeeResponseDTO
LoginRequestDTO
LoginResponseDTO
```

Models used for API serialization should normally conform to `Codable`.

DTOs must not leak into the Presentation or Domain layers.

---

## Mappers

Mappers convert Data models into Domain entities and vice versa when necessary.

Example:

```text
CoffeeResponseDTO
       ↓
   CoffeeMapper
       ↓
     Coffee
```

This prevents API contracts from becoming business entities.

---

## Repository Implementations

Concrete repositories live in the Data layer.

Example:

```text
Domain
└── CoffeeRepository

Data
└── DefaultCoffeeRepository
```

The implementation may coordinate multiple Data Sources while conforming to the Domain protocol.

---

# Dependency Direction

The expected dependency direction is:

```text
Presentation
     │
     ▼
   Domain
     ▲
     │
    Data
```

Or, from the perspective of abstractions:

```text
View
  ↓
ViewController
  ↓
ViewModel
  ↓
UseCase
  ↓
Repository Protocol
  ↑
Repository Implementation
  ↓
DataSource
```

The Repository implementation depends on the Domain abstraction, not the other way around.

---

# Dependency Injection

Coffee Call uses manual Dependency Injection.

Preferred approaches:

- Initializer Injection
- Factory Pattern

Example:

```swift
final class CoffeeListViewModel {

    private let fetchCoffeeCatalogUseCase: FetchCoffeeCatalogUseCaseProtocol

    init(
        fetchCoffeeCatalogUseCase: FetchCoffeeCatalogUseCaseProtocol
    ) {
        self.fetchCoffeeCatalogUseCase = fetchCoffeeCatalogUseCase
    }
}
```

Dependencies must be explicit.

Avoid:

- Global mutable dependencies
- Service locators
- Singleton-based dependency graphs
- Heavy DI containers

Factories may be introduced when object creation becomes sufficiently complex.

---

# Feature Organization

Business functionality belongs under `Features/`.

Target structure:

```text
Features/
└── FeatureName/
    ├── Presentation/
    │   ├── Coordinator/
    │   ├── View/
    │   ├── ViewController/
    │   └── ViewModel/
    │
    ├── Domain/
    │   ├── Entities/
    │   ├── Repositories/
    │   └── UseCases/
    │
    └── Data/
        ├── DataSources/
        ├── Mappers/
        ├── Models/
        └── Repositories/
```

This complete structure should not be created automatically for every feature.

Only create a layer or directory when the feature actually requires it.

This avoids empty folders and unnecessary abstractions.

---

# Shared Code

Shared application infrastructure belongs under `Core/`.

Examples:

```text
Core/
├── Extensions/
├── Navigation/
├── Networking/
├── Storage/
└── Utilities/
```

A component should only move into `Core` when it is genuinely shared by multiple features.

Feature-specific logic must remain inside its feature.

---

# Reusable UI Components

Reusable visual components should live under:

```text
UIComponents/
```

Examples:

```text
PrimaryButton
LoadingView
CoffeeCardView
AppTextField
```

A component should only become shared after there is a real reuse case.

Avoid moving feature-specific Views into `UIComponents` prematurely.

---

# UI Architecture

Coffee Call uses UIKit with programmatic View Code.

Application screens must not use Storyboards or XIBs.

The only current exception is:

```text
LaunchScreen.storyboard
```

which is used exclusively as the system launch screen.

Layout should use:

```text
NSLayoutAnchor
```

Third-party layout frameworks should not be introduced unless native APIs become a measurable source of complexity.

---

# Concurrency

Coffee Call uses Swift Structured Concurrency for asynchronous operations.

Preferred:

```swift
async
await
Task
```

Typical use cases:

- Networking
- File I/O
- Repository operations
- DataSource operations

Combine is reserved primarily for:

```text
ViewModel ↔ ViewController bindings
```

Avoid mixing Combine and async/await for the same responsibility.

Grand Central Dispatch should only be used when Structured Concurrency cannot adequately solve the problem.

---

# Networking

Networking will be built around:

```text
URLSession
      ↓
NetworkService Protocol
      ↓
RemoteDataSource
      ↓
Repository
```

Networking infrastructure should be protocol-based to support testing.

Example conceptual interface:

```swift
protocol NetworkService {
    func request<Response: Decodable>(
        _ request: URLRequest,
        responseType: Response.Type
    ) async throws -> Response
}
```

Networking errors should be mapped into meaningful errors before reaching higher layers when appropriate.

---

# Persistence

Storage strategy depends on the type of information.

### Keychain

Use for:

- Authentication tokens
- Secrets
- Sensitive credentials

### UserDefaults

Use for:

- Simple preferences
- Feature flags
- Primitive configuration values

### FileManager

Use for:

- Large cached files
- Downloaded assets
- File-based application data

### Core Data

Use only when the application requires complex persistent relationships or querying.

Persistence abstractions should be protocol-based when consumed by business logic.

---

# Testing Strategy

Coffee Call uses XCTest.

Priority should be given to unit tests for:

```text
ViewModels
UseCases
Repositories
Services
Mappers
Business Rules
```

Tests should follow:

```swift
func test_<givenCondition>_<whenAction>_<thenExpectation>()
```

Example:

```swift
func test_lastPage_whenNextIsRequested_thenFinishesOnboarding()
```

External dependencies should be replaced with simple mocks, spies, or fakes conforming to production protocols.

Avoid introducing mocking frameworks unless they provide clear value.

Critical Domain and Data code should target at least 70% test coverage.

Coverage itself is not a substitute for meaningful assertions.

---

# Memory Management

Closures that capture owning objects must be reviewed for retain cycles.

Prefer weak captures where a closure should not retain its owner:

```swift
{ [weak self] in
    self?.handleEvent()
}
```

Delegates should generally use weak references when ownership semantics require it.

Memory behavior should be periodically validated with Instruments:

- Leaks
- Allocations

---

# Security

Coffee Call follows these security rules:

- Never commit secrets into the repository
- Never log authentication tokens or sensitive information
- Store sensitive credentials in Keychain
- Use HTTPS for remote communication
- Avoid storing secrets in UserDefaults
- Keep infrastructure configuration separate from business logic

Security requirements should evolve alongside authentication and networking features.

---

# Current Project Structure

The current codebase intentionally contains only the architecture required by implemented features:

```text
CoffeeCall/
├── Core/
│   ├── Extensions/
│   │   └── UIFont+AppFonts.swift
│   │
│   └── Navigation/
│       ├── AppCoordinator.swift
│       └── Coordinator.swift
│
├── Features/
│   └── Onboarding/
│       ├── Welcome/
│       │   ├── WelcomeView.swift
│       │   ├── WelcomeViewController.swift
│       │   └── WelcomeViewModel.swift
│       │
│       └── OnboardingCoordinator.swift
│
└── Resources/
    └── Fonts/
        └── Poppins-Regular.ttf
```

The project will migrate incrementally toward the complete Clean Architecture feature structure as business complexity increases.

---

# Future Modularization

The feature-oriented structure is intentionally designed to simplify future extraction into Swift Packages.

Potential modules may eventually include:

```text
CoffeeCallCore
CoffeeCallNetworking
CoffeeCallDesignSystem
AuthenticationFeature
CatalogFeature
CartFeature
CheckoutFeature
```

Swift Package extraction should only happen when module boundaries and reuse justify the additional complexity.

The application should remain modular by design before becoming modular by build system.

---

# Architectural Decision Rule

When deciding whether to introduce a new abstraction, layer, protocol, or shared component, ask:

1. Does it solve an existing problem?
2. Does it improve testability or separation of concerns?
3. Does it reduce meaningful coupling?
4. Is there more than one realistic implementation or consumer?
5. Is the added complexity justified?

If the answer is unclear, prefer the simpler implementation.

Architecture exists to support the product, not to maximize the number of abstractions.
