//
//  CoordinatorTests.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import Testing
import UIKit
@testable import NewsApp

@MainActor
@Suite("Coordinator Tests")
struct CoordinatorTests {
    let sut: AppCoordinator
    let navigation = MockNavigation()

    init () {
        let dependencies = AppCoordinator.Dependencies(navigation: navigation)
        sut = AppCoordinator(dependencies: dependencies)
    }

    @Test("Create initial screen creates the screen and sets it as the navigation route")
    func createInitialScreen() throws {
        let providedViewController = UIViewController()
        let screenBuilder = MockScreenBuilder()
        screenBuilder.makeReturnValue = providedViewController
        let screen = Screen(builder: screenBuilder.make)
        let window = try sut.createInitialScreen(screen: screen, windowScene: getWindowScene())

        // Create Screen
        #expect(screenBuilder.makeValues.count == 1)
        let coordinator = try #require(screenBuilder.makeValues.first as? AppCoordinator)
        #expect(coordinator === sut)

        // Add to navigation
        #expect(navigation.setViewControllerValues.count == 1)
        let viewControllers = try #require(navigation.setViewControllerValues.first?.viewControllers)
        #expect(viewControllers.count == 1)
        let viewController = try #require(viewControllers.first)
        #expect(viewController === providedViewController)

        // Add navigation to window
        #expect(window.rootViewController === navigation)
        #expect(window.isKeyWindow == true)
    }

    @Test("Navigate to, calls the view builder and pushes the new screen")
    func navigateTo_pushViewController() throws {
        let providedViewController = UIViewController()
        let screenBuilder = MockScreenBuilder()
        screenBuilder.makeReturnValue = providedViewController
        let screen = Screen(builder: screenBuilder.make)

        sut.navigate(to: screen, animated: false)

        // Create Screen
        #expect(screenBuilder.makeValues.count == 1)
        let coordinator = try #require(screenBuilder.makeValues.first as? AppCoordinator)
        #expect(coordinator === sut)

        // Add to navigation
        #expect(navigation.pushViewControllerValues.count == 1)
        let viewController = try #require(navigation.pushViewControllerValues.first?.viewController)
        #expect(viewController === providedViewController)
    }

    @Test("Navigate to, calls the view builder and replaces the root view if it is the Splash Screen")
    func navigateTo_setViewControllers() throws {
        let splashScreen = SplashScreenViewController(viewModel: MockSplashScreenViewModel())
        navigation.visibleViewControllerReturnValue = splashScreen

        let providedViewController = UIViewController()
        let screenBuilder = MockScreenBuilder()
        screenBuilder.makeReturnValue = providedViewController
        let screen = Screen(builder: screenBuilder.make)

        sut.navigate(to: screen, animated: false)

        // Create Screen
        #expect(screenBuilder.makeValues.count == 1)
        let coordinator = try #require(screenBuilder.makeValues.first as? AppCoordinator)
        #expect(coordinator === sut)

        // Add to navigation
        #expect(navigation.setViewControllerValues.count == 1)
        let viewControllers = try #require(navigation.setViewControllerValues.first?.viewControllers)
        #expect(viewControllers.count == 1)
        let viewController = try #require(viewControllers.first)
        #expect(viewController === providedViewController)
    }

    private func getWindowScene() throws -> UIWindowScene {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw TestError.windowScene
        }
        return windowScene
    }

    private struct TestError: Error {
        static var windowScene = Self()
    }
}

extension Screen {
    fileprivate static func mock(builder: @escaping (Coordinator) -> UIViewController) -> Screen {
        Screen(builder: builder)
    }
}

fileprivate final class MockScreenBuilder {
    var makeValues = [Coordinator]()
    var makeReturnValue = UIViewController()

    func make(coordinator: Coordinator) -> UIViewController {
        makeValues.append(coordinator)
        return makeReturnValue
    }
}
