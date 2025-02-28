//
//  FullHeadlines.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import Foundation
import NewsService

protocol HeadlinesModel {
    init?(article: Article)
}

struct FullHeadlines {
    let author: String?
    let title: String
    let description: String
    let publishedAt: Date
    let urlToImage: URL
}

extension FullHeadlines: HeadlinesModel {
    init?(article: Article) {
        guard
            let description = article.description,
            let urlToImage = article.urlToImage
        else {
            return nil
        }

        self.author = article.author
        self.title = article.title
        self.description = description
        self.publishedAt = article.publishedAt
        self.urlToImage = urlToImage
    }
}
