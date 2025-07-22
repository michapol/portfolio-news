//
//  FullHeadlines.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import NewsService
import UIKit

protocol HeadlinesModel {
    var cell: HeadlinesCell.Type { get }
    init?(article: Article)
}

struct FullHeadlines {
    let cell: HeadlinesCell.Type = FullHeadlinesCell.self

    let author: String?
    let title: String
    let description: String?
    let publishedAt: Date
    let urlToImage: URL?
}

extension FullHeadlines: HeadlinesModel {
    init(article: Article) {
        self.author = article.author
        self.title = article.title
        self.description = article.description
        self.publishedAt = article.publishedAt
        self.urlToImage = article.urlToImage
    }
}
