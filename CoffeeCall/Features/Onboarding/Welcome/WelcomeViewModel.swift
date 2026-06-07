//
//  WelcomeViewModel.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 15/12/25.
//

import Foundation
import Combine

protocol WelcomeViewModelDelegate: AnyObject {
    func didFinishOnboarding()
}

struct OnboardingPage {
    let title: String
    let subtitle: String
}

final class WelcomeViewModel {

    // MARK: - Delegate
    weak var delegate: WelcomeViewModelDelegate?

    // MARK: - Data Source
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Magic Coffee", subtitle: "Feel yourself like a barista!\nMagic coffee on order."),
        OnboardingPage(title: "Quality First", subtitle: "Discover new flavors!\nExplore our premium roasts."),
        OnboardingPage(title: "Enjoy", subtitle: "Enjoy your moment!\nDelivered hot and fresh.")
    ]

    // MARK: - State (Combine Binding)
    @Published private(set) var currentPageIndex: Int = 0

    // MARK: - Actions
    func nextButtonTapped() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
        } else {
            delegate?.didFinishOnboarding()
        }
    }

    func pageControlChanged(to index: Int) {
        guard index >= 0 && index < pages.count else { return }
        currentPageIndex = index
    }
}
