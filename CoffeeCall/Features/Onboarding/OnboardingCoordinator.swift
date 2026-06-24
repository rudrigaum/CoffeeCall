//
//  OnboardingCoordinator.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 10/12/25.
//

import Foundation
import UIKit

final class OnboardingCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Lifecycle
    func start() {
        let viewModel = WelcomeViewModel()
        viewModel.delegate = self
        let viewController = WelcomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Navigation Actions
    private func showLogin() {
        print("DEBUG: Navegar para Login ou Próxima tela do Onboarding")
    }
}

// MARK: - WelcomeViewModelDelegate
extension OnboardingCoordinator: WelcomeViewModelDelegate {
    func didFinishOnboarding() {
        showLogin()
    }
}
