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
        setupNewsRepository()

        do {
            try await performInitialFetch()
            await delayNavigation(from: appeared, for: dependencies.minimumDisplayTime)
            await dependencies.coordinator.navigate(to: .headlines, animated: true)
        } catch {
            errorHandler(error)
        }
    }

    private func setupNewsRepository() {
        let repository = dependencies.newsRepository.init(dependencies: dependencies.newsRepositoryDependencies)
        dependencies.newsRepository.shared = repository
    }

    private func performInitialFetch() async throws {
        guard let repository = dependencies.newsRepository.shared else {
            throw NewsRepositoryError.sharedInstance
        }
        try await repository.preload(category: .general)
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
        let newsRepository: any SharedNewsRepository.Type
        let newsRepositoryDependencies: NewsRepository.Dependencies

        static func `default`(apiKey: String, coordinator: any Coordinator) -> Self {
            .init(
                coordinator: coordinator,
                minimumDisplayTime: 3.0,
                newsRepository: NewsRepository.self,
                newsRepositoryDependencies: .default(apiKey: apiKey)
            )
        }
    }
}
