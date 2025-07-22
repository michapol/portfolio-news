//
//  SplashScreenFactory.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import UIKit

enum SplashScreenFactory {
    static func make(coordinator: Coordinator) -> UIViewController {
        let viewModelDependencies = SplashScreenViewModel.Dependencies.default(
            apiKey: "<API KEY",
            coordinator: coordinator
        )
        let viewModel = SplashScreenViewModel(dependencies: viewModelDependencies)
        return SplashScreenViewController(viewModel: viewModel)
    }
}
