//
//  HeadlinesScreenViewModel.swift
//  NewsApp
//
//  Created by Mike Pollard on 04/03/2025.
//

import Foundation
import NewsService
import UIKit

final class HeadlinesScreenViewModel {
    private let dependencies: Dependencies
    private let categories: [NewsCategory] = [
        .general,
        .entertainment,
        .science,
        .technology,
        .health,
        .business,
        .sports
    ]

    private var headlines: [NewsCategory: [HeadlinesModel]] = [:]

    init(dependencies: Dependencies = .default) {
        self.dependencies = dependencies
    }
}

extension HeadlinesScreenViewModel {
    func fetchSections() async {
        for category in self.categories {
            let headlines = await dependencies.repository.provide(for: category, mapper: mapArticle)
            self.headlines[category] = headlines
        }
    }

    func mapArticle(_ article: Article) -> (any HeadlinesModel)? {
        FullHeadlines(article: article)
    }
}

extension HeadlinesScreenViewModel {
    func numSections() -> Int {
        self.categories.count
    }

    func numHeadlines(for section: Int) -> Int {
        let category = catgeory(for: section)
        return headlines[category]?.count ?? 0
    }

    func headline(for indexPath: IndexPath) -> HeadlinesModel? {
        let category = catgeory(for: indexPath.section)
        guard let headlines = self.headlines[category] else { return nil }
        guard indexPath.item < headlines.count else { return nil }
        return headlines[indexPath.item]
    }

    func catgeory(for section: Int) -> NewsCategory {
        guard section < self.categories.count else { return .general }
        return self.categories[section]
    }
}

extension HeadlinesScreenViewModel {
    struct Dependencies {
        let repository: SharedNewsRepository

        static var `default`: Self {
            .init(repository: NewsRepository.shared)
        }
    }
}

extension NewsCategory {
    var colour: UIColor {
        switch self {
        case .general:          return .white
        case .entertainment:    return .white
        case .science:          return .white
        case .technology:       return .white
        case .health:           return .white
        case .business:         return .white
        case .sports:           return .white
        }
    }

    var title: String {
        switch self {
        case .general:
            return "Headline News".uppercased()
        case .entertainment, .science, .technology, .health, .business, .sports:
            return self.rawValue.uppercased()
        }
    }
}
