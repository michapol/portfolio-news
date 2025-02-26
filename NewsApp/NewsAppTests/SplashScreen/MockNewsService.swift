//
//  MockNewsService.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 26/02/2025.
//

import NewsService

final class MockNewsService: NewsProvider, @unchecked Sendable {
    var getHeadlinesValues = [NewsCategory]()
    var getHeadlinesReturnValue = [Article]()
    var getHeadlinesError: MockNewsAppError?

    func getHeadlines(for category: NewsCategory) async throws -> [Article] {
        getHeadlinesValues.append(category)
        if let getHeadlinesError {
            throw getHeadlinesError
        }
        return getHeadlinesReturnValue
    }
}
