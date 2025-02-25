//
//  ViewController.swift
//  NewsApp
//
//  Created by Mike Pollard on 25/02/2025.
//

import NewsService
import SwiftUI
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Task {
            await testNewsService()
        }
    }

    private func testNewsService() async {
        let newsService = NewsService(apiKey: "<APIKEY>")
        guard let articles = try? await newsService.getHeadlines(for: .business) else { return }

        print(articles)
    }
}
