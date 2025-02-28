//
//  Coordinator.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    func createInitialScreen(screen: Screen, windowScene: UIWindowScene) -> UIWindow
    func navigate(to screen: Screen, animated: Bool)
}

final class AppCoordinator {
    private let dependencies: Dependencies

    init(dependencies: Dependencies = .default) {
        self.dependencies = dependencies
    }

    func createInitialScreen(screen: Screen, windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)

        let initialView = screen.builder(self)
        dependencies.navigation.setViewControllers([initialView], animated: false)
        window.rootViewController = dependencies.navigation as? UIViewController
        window.makeKeyAndVisible()
        return window
    }

    func navigate(to screen: Screen, animated: Bool) {
        let viewController = screen.builder(self)

        if dependencies.navigation.visibleViewController is SplashScreenViewController {
            dependencies.navigation.setViewControllers([viewController], animated: animated)
        } else {
            dependencies.navigation.pushViewController(viewController, animated: animated)
        }
    }
}

extension AppCoordinator {
    struct Dependencies {
        let navigation: any Navigation

        static var `default`: Self {
            .init(navigation: AppNavigation())
        }
    }
}
extension AppCoordinator: Coordinator {}
