//
//  MockCoordinator.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import UIKit
@testable import NewsApp

final class MockCoordinator: Coordinator {
    // MARK: - Create Initial Screen

    var createInitialScreenValues = [CreateInitialScreenValues]()
    var createInitialScreenReturnValue = UIWindow()

    func createInitialScreen(screen: Screen, windowScene: UIWindowScene) -> UIWindow {
        createInitialScreenValues.append(.init(screen: screen, windowScene: windowScene))
        return createInitialScreenReturnValue
    }

    // MARK: - Navigate

    var navigateValues = [NavigateValues]()

    func navigate(to screen: Screen, animated: Bool) {
        navigateValues.append(.init(screen: screen, animated: animated))
    }
}

extension MockCoordinator {
    struct CreateInitialScreenValues {
        let screen: Screen
        let windowScene: UIWindowScene
    }

    struct NavigateValues: Equatable {
        let screen: Screen
        let animated: Bool
    }
}

extension Screen: @retroactive Equatable {
    public static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}
