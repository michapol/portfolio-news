//
//  HeadlinesScreenFactory.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

enum HeadlinesScreenFactory {
    static func make(coordinator: Coordinator) -> UIViewController {
        HeadlinesScreenViewController()
    }
}
