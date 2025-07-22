//
//  MockNewsRepository.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import NewsService
@testable import NewsApp

final class MockNewsRepository: SharedNewsRepository {
    // MARK: Preload

    var preloadValues = [NewsCategory]()
    var preloadError: Error?

    func preload(category: NewsCategory) async throws {
        preloadValues.append(category)

        if let preloadError {
            throw preloadError
        }
    }

    // MARK: Provide

    var provideValues = [NewsCategory]()
    var provideReturnValue = [Any]()

    func provide<T>(for category: NewsCategory) async throws -> [T] where T: HeadlinesModel {
        provideValues.append(category)
        return provideReturnValue.compactMap { $0 as? T }
    }
}
