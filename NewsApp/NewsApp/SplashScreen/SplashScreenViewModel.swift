//
//  SplashScreenViewModel.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import Foundation

protocol SplashScreenViewModelProtocol {
    var errorHandler: (Error) -> Void { get set }
    func screenAppeared() async
}

struct SplashScreenViewModel {
    private let dependencies: Dependencies
    private var _errorHandler: (Error) -> Void = { _ in }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SplashScreenViewModel: SplashScreenViewModelProtocol {
    var errorHandler: (any Error) -> Void {
        get { _errorHandler }
        set { _errorHandler = newValue }
    }

    func screenAppeared() async {
        let appeared: Date = .now

        do {
            try await dependencies.newsRepository.preload()
            await delayNavigation(from: appeared, for: dependencies.minimumDisplayTime)
            await dependencies.coordinator.navigate(to: .headlines, animated: true)
        } catch {
            errorHandler(error)
        }
    }

    private func delayNavigation(from start: Date, for delay: TimeInterval) async {
        let timeDifference = Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
        let remainingDelay = max(0, delay - timeDifference)
        let nanoseconds = UInt64(remainingDelay * 1_000_000_000)

        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}

extension SplashScreenViewModel {
    struct Dependencies {
        let coordinator: any Coordinator
        let minimumDisplayTime: TimeInterval
        let newsRepository: any SharedNewsRepository

        static func `default`(apiKey: String, coordinator: any Coordinator) -> Self {
            .init(
                coordinator: coordinator,
                minimumDisplayTime: 3.0,
                newsRepository: NewsRepository.shared
            )
        }
    }
}
