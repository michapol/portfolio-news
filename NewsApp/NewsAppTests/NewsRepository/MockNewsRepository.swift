//
//  MockNewsRepository.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import NewsService
@testable import NewsApp

final class MockNewsRepository: SharedNewsRepository {
    // MARK: Shared

    static var sharedValues = [(any SharedNewsRepository)?]()
    static var sharedReturnValue: (any SharedNewsRepository)?
    static var shouldReturnLastValue: Bool = true
    static func resetShared() {
        sharedValues.removeAll(keepingCapacity: true)
        sharedReturnValue = nil
        shouldReturnLastValue = true
    }

    static var shared: (any SharedNewsRepository)? {
        get { shouldReturnLastValue ? sharedValues.last as? SharedNewsRepository : sharedReturnValue }
        set { sharedValues.append(newValue) }
    }

    // MARK: Init

    var initValues: NewsRepository.Dependencies

    init(dependencies: NewsRepository.Dependencies) {
        initValues = dependencies
    }

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
