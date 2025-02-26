//
//  SplashScreenViewModelTests.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 26/02/2025.
//

import Testing
@testable import NewsApp

@Suite("Splash screen view model tests")
struct SplashScreenViewModelTests {
    private var sut: SplashScreenViewModel
    private let newsService: MockNewsService

    init() {
        newsService = MockNewsService()
        sut = SplashScreenViewModel(dependencies: .init(newsService: newsService))
    }

    @Test("Screen appeared fetches general headlines")
    func screenAppeared() async {
        await sut.screenAppeared()

        #expect(newsService.getHeadlinesValues == [.general])
    }

    @Test("Screen appeared calls error handler on error")
    mutating func screenAppearedError() async {
        let expectedError = MockNewsAppError.mockNewsService
        newsService.getHeadlinesError = expectedError

        let errorHandler = MockErrorHandler()
        sut.errorHandler = errorHandler.errorHandler

        await sut.screenAppeared()

        #expect(errorHandler.errorHandlerValues == [expectedError])
   }
}
