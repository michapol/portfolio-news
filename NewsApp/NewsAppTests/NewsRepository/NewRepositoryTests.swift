//
//  NewRepositoryTests.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import NewsService
import Testing
@testable import NewsApp

@Suite("News Repository Tests")
struct NewsRepositoryTests {
    let sut: NewsRepository
    let newsService = MockNewsService()

    init() {
        let dependencies = NewsRepository.Dependencies(newsService: newsService)
        sut = NewsRepository(dependencies: dependencies)
    }

    @Test("Preload calls news service, get headlines with category")
    func preload() async throws {
        let category: NewsCategory = .technology

        try await sut.preload(category: category)

        #expect(newsService.getHeadlinesValues == [category])
    }

    @Test("Provide returns articles from cache when available")
    func provide_fromCache() async throws {
        let category: NewsCategory = .sports
        newsService.getHeadlinesReturnValue = []

        try await sut.preload(category: category)
        #expect(newsService.getHeadlinesValues.count == 1)

        let _: [MockArticle] = try await sut.provide(for: category)
        #expect(newsService.getHeadlinesValues.count == 1)
    }

    @Test("Provide calls news service, get headlines with category")
    func provide_fromNewsService() async throws {
        let category: NewsCategory = .science

        let _: [MockArticle] = try await sut.provide(for: category)
        #expect(newsService.getHeadlinesValues == [category])
    }
}
