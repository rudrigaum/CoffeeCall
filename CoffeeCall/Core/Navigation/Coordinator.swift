//
//  Coordinator.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 10/12/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func childDidFinish(_ child: Coordinator?)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        guard let child,
              let index = childCoordinators.firstIndex(where: { $0 === child }) else {
            return
        }

        childCoordinators.remove(at: index)
    }
}
