//
//  MockErrorHandler.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 26/02/2025.
//

final class MockErrorHandler {
    var errorHandlerValues = [Error]()

    func errorHandler(_ error: Error) {
        errorHandlerValues.append(error)
    }
}
