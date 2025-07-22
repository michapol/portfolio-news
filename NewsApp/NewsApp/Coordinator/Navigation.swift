//
//  Navigation.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import UIKit

protocol Navigation {
    var titleView: UILabel { get }
    var visibleViewController: UIViewController? { get }

    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

final class AppNavigation: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = nil

        navigationBar.standardAppearance = appearance
    }
}

extension AppNavigation: Navigation {
    var titleView: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0, weight: .black)
        label.text = " headlines ".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .init(width: 3.0, height: 3.0)
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shouldRasterize = true
        return label
    }
}
