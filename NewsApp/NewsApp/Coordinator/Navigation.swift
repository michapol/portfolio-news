//
//  Navigation.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import UIKit

protocol Navigation {
    var visibleViewController: UIViewController? { get }

    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

final class AppNavigation: UINavigationController {}

extension AppNavigation: Navigation {}
