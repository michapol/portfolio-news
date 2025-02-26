//
//  SplashScreenViewModel.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import Foundation
import NewsService

protocol SplashScreenViewModelProtocol {
    var errorHandler: (Error) -> Void { get set }
    func screenAppeared() async
}

struct SplashScreenViewModel {
    private let dependencies: Dependencies
    private var _errorHandler: (Error) -> Void = { _ in }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SplashScreenViewModel: SplashScreenViewModelProtocol {
    var errorHandler: (any Error) -> Void {
        get { _errorHandler }
        set { _errorHandler = newValue }
    }
    
    func screenAppeared() async {
        do {
            let articles = try await dependencies.newsService.getHeadlines(for: .general)
            print(articles)
        } catch {
            errorHandler(error)
        }
    }
}

extension SplashScreenViewModel {
    struct Dependencies {
        let newsService: NewsProvider

        static func `default`(apiKey: String) -> Self {
            .init(newsService: NewsService(apiKey: apiKey))
        }
    }
}
