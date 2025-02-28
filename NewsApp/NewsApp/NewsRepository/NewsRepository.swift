//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import NewsService

protocol SharedNewsRepository {
    static var shared: SharedNewsRepository? { get set }

    init(dependencies: NewsRepository.Dependencies)

    func preload(category: NewsCategory) async throws
    func provide<T: HeadlinesModel>(for category: NewsCategory) async throws -> [T]
}

actor NewsRepository: SharedNewsRepository {
    static var shared: SharedNewsRepository?

    private var headlines: [NewsCategory: [Article]] = [:]
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func preload(category: NewsCategory) async throws {
        let articles = try await dependencies.newsService.getHeadlines(for: category)
        headlines[category] = articles
    }

    func provide<T>(for category: NewsCategory) async throws -> [T] where T: HeadlinesModel {
        if let articles = headlines[category] {
            return articles.compactMap { T(article: $0) }
        }

        let articles = try await dependencies.newsService.getHeadlines(for: category)
        headlines[category] = articles

        return articles.compactMap { T(article: $0) }
    }
}

extension NewsRepository {
    struct Dependencies {
        let newsService: any NewsProvider

        static func `default`(apiKey: String) -> Self {
            .init(newsService: NewsService(apiKey: apiKey))
        }
    }
}

extension NewsRepository: Sendable {}
