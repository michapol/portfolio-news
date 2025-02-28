//
//  HeadlinesScreenViewController.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

final class HeadlinesScreenViewController: UIViewController {
    // MARK: - UI Elements

    private let layout = UICollectionViewLayout()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange
    }
}
