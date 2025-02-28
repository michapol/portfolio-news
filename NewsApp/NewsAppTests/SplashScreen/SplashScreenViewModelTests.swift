//
//  SplashScreenViewModelTests.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 26/02/2025.
//

import Testing
@testable import NewsApp

@Suite("Splash screen view model tests", .serialized)
struct SplashScreenViewModelTests {
    private var sut: SplashScreenViewModel

    private let coordinator: MockCoordinator
    private let newsRepository = MockNewsRepository.self
    private let newsService = MockNewsService()

    @MainActor
    init() {
        coordinator = MockCoordinator()
        let dependencies = SplashScreenViewModel.Dependencies(
            coordinator: coordinator,
            minimumDisplayTime: 0.0,
            newsRepository: newsRepository,
            newsRepositoryDependencies: .init(newsService: newsService)
        )
        sut = SplashScreenViewModel(dependencies: dependencies)
    }

    @Test("Screen appeared configures news repository")
    func screenAppeared_newsRepository() async throws {
        await sut.screenAppeared()

        #expect(newsRepository.sharedValues.count == 1)
        let configuredNewsRepository = try #require(newsRepository.sharedValues.first as? MockNewsRepository)
        let configuredNewsService = try #require(configuredNewsRepository.initValues.newsService as? MockNewsService)
        #expect(configuredNewsService === newsService)
    }

    @Test("Screen appeared preloads general headlines")
    func screenAppeared_preload() async throws {
        await sut.screenAppeared()

        let configuredNewsRepository = try #require(newsRepository.sharedValues.first as? MockNewsRepository)
        #expect(configuredNewsRepository.preloadValues == [.general])
    }

    @Test("Screen appeared navigates to next screen")
    func screenAppeared_navigation() async {
        await sut.screenAppeared()

        let expectedValues = MockCoordinator.NavigateValues(
            screen: .headlines,
            animated: true
        )
        await #expect(coordinator.navigateValues == [expectedValues])
    }

    @Test("Screen appeared calls error handler on error")
    mutating func screenAppearedError() async {
        newsRepository.shouldReturnLastValue = false

        let errorHandler = MockErrorHandler()
        sut.errorHandler = errorHandler.errorHandler

        await sut.screenAppeared()

        #expect(errorHandler.errorHandlerValues.compactMap { $0 as? NewsRepositoryError } == [NewsRepositoryError.sharedInstance])
   }
}
