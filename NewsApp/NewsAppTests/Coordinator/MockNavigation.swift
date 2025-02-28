//
//  MockNavigation.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import UIKit
@testable import NewsApp

final class MockNavigation: UIViewController, Navigation {
    // MARK: - Visible View Controller

    var visibleViewControllerCalledCount = 0
    var visibleViewControllerReturnValue: UIViewController?

    var visibleViewController: UIViewController? {
        visibleViewControllerCalledCount += 1
        return visibleViewControllerReturnValue
    }

    // MARK: - Push View Controller

    var pushViewControllerValues = [PushViewControllerValues]()

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerValues.append(.init(viewController: viewController, animated: animated))
    }

    // MARK: - Set View Controllers

    var setViewControllerValues = [SetViewControllerValues]()

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        setViewControllerValues.append(.init(viewControllers: viewControllers, animated: animated))
    }
}

extension MockNavigation {
    struct PushViewControllerValues {
        let viewController: UIViewController
        let animated: Bool
    }

    struct SetViewControllerValues {
        let viewControllers: [UIViewController]
        let animated: Bool
    }
}
