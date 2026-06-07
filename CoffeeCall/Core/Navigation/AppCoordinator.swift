//
//  AppCoordinator.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 10/12/25.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    // MARK: - Coordinator Lifecycle
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showOnboarding()
    }
    
    // MARK: - Navigation Flows
    private func showOnboarding() {
        let child = OnboardingCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
