//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import NewsService

protocol SharedNewsRepository {
    func preload() async throws
    func provide(for category: NewsCategory, mapper: (Article) -> HeadlinesModel?) async -> [HeadlinesModel]
}

actor NewsRepository: SharedNewsRepository {
    static let shared: SharedNewsRepository = NewsRepository()

    private var articles: [NewsCategory: [Article]] = [:]
    private let dependencies: Dependencies

    init(dependencies: Dependencies = .default) {
        self.dependencies = dependencies
    }

    func preload() async throws {
        for category in NewsCategory.allCases {
            let articles = try await dependencies.newsService.getHeadlines(for: category)
            self.articles[category] = articles
        }
    }

    func provide(for category: NewsCategory, mapper: (Article) -> HeadlinesModel?) -> [HeadlinesModel] {
        guard let articles = self.articles[category] else { return [] }
        return articles.compactMap(mapper)
    }
}

extension NewsRepository {
    struct Dependencies {
        let newsService: any NewsProvider

        static var `default`: Self {
            .init(newsService: NewsService(apiKey: KeyStore.newsAPIKey))
        }
    }
}

extension NewsRepository: Sendable {}
