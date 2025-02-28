//
//  MockArticle.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import NewsService
@testable import NewsApp

struct MockArticle: HeadlinesModel {
    var initValue: Article

    init?(article: Article) {
        self.initValue = article
    }
}
