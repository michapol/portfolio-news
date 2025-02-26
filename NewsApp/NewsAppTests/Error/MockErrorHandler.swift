//
//  MockErrorHandler.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 26/02/2025.
//

final class MockErrorHandler {
    var errorHandlerValues = [MockNewsAppError?]()

    func errorHandler(_ error: Error) {
        errorHandlerValues.append(error as? MockNewsAppError)
    }
}
