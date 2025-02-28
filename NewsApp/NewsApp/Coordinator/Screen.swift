//
//  Screen.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

struct Screen {
    let id = UUID()
    let builder: (Coordinator) -> UIViewController
}

extension Screen {
    static let headlines = Screen(builder: HeadlinesScreenFactory.make)
    static let splash = Screen(builder: SplashScreenFactory.make)
}
