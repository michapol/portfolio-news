//
//  MockSplashScreenViewModel.swift
//  NewsAppTests
//
//  Created by Mike Pollard on 28/02/2025.
//

import UIKit
@testable import NewsApp

final class MockSplashScreenViewModel: SplashScreenViewModelProtocol {
    // MARK: - Error Handler

    var errorHandlerValues = [(any Error) -> Void]()
    var errorHandlerReturnValue: (any Error) -> Void = { _ in }

    var errorHandler: (any Error) -> Void {
        get { errorHandlerReturnValue }
        set { errorHandlerValues.append(newValue) }
    }

    // MARK: - Screen Appeared

    var screenAppearedCalledCount = 0

    func screenAppeared() async {
        screenAppearedCalledCount += 1
    }
}
