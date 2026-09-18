# Coffee Call ☕

Coffee Call is a native iOS application designed to provide a simple, fluid, and visually engaging coffee ordering experience.

The project is also built as a study and portfolio application focused on scalable iOS architecture, maintainability, testability, and modern development practices using UIKit.

## 📱 Overview

Coffee Call aims to reduce friction in premium coffee ordering by providing an intuitive experience for discovering coffee options and, as the product evolves, managing orders and purchases.

The application is currently in the early MVP stage, with the project foundation and onboarding flow under development.

## ✨ Current Features

- Programmatic UIKit interface
- Custom font support
- Reactive onboarding flow with Combine
- Coordinator-based navigation
- MVVM presentation architecture
- Feature-oriented project organization
- Repository formatting and Git configuration
- Development automation through Makefile

## 🛠 Tech Stack

- Swift 5.9+
- UIKit
- Combine
- XCTest
- async/await
- NSLayoutAnchor
- Xcode 15+

No third-party UI or architecture dependencies are currently used.

## 🏗 Architecture

Coffee Call follows Clean Architecture principles combined with MVVM-C.

The application is organized around three main responsibilities:

- **Presentation** — Views, ViewControllers, ViewModels, and Coordinators
- **Domain** — Business rules, entities, use cases, and repository abstractions
- **Data** — Repository implementations, data sources, models, and mappers

Navigation responsibilities are delegated to Coordinators, keeping ViewControllers focused on lifecycle management, UI bindings, and user interaction.

Dependencies should be explicitly injected through initializers or factories.

For more details, see `ARCHITECTURE.md` once the architecture documentation is introduced.

## 📂 Project Structure

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
├── Resources/
│   └── Fonts/
│       └── Poppins-Regular.ttf
│
├── AppDelegate.swift
├── SceneDelegate.swift
├── Assets.xcassets
├── Info.plist
└── LaunchScreen.storyboard
