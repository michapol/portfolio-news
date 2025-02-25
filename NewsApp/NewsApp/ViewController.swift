//
//  ViewController.swift
//  NewsApp
//
//  Created by Mike Pollard on 25/02/2025.
//

import NewsService
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
        guard let data = try? await newsService.getHeadlines(for: .technology) else { return }
        guard let string = String(data: data, encoding: .utf8) else { return }

        print(string)
    }
}
