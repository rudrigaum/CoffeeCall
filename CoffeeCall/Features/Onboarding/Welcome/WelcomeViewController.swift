//
//  WelcomeViewController.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 15/12/25.
//

import Foundation
import UIKit
import Combine

final class WelcomeViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: WelcomeViewModel
    private var cancellables = Set<AnyCancellable>()

    private var customView: WelcomeView? {
        return view as? WelcomeView
    }

    // MARK: - Init
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = WelcomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Bindings
    private func setupBindings() {
        customView?.onNextButtonTapped = { [weak self] in
            self?.viewModel.nextButtonTapped()
        }

        customView?.onPageControlTapped = { [weak self] index in
            self?.viewModel.pageControlChanged(to: index)
        }

        viewModel.$currentPageIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self else { return }

                let page = self.viewModel.pages[index]

                self.customView?.updateDisplay(
                    title: page.title,
                    subtitle: page.subtitle,
                    currentPage: index,
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}
