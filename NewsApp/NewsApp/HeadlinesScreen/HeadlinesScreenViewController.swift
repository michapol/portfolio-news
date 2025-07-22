//
//  HeadlinesScreenViewController.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

final class HeadlinesScreenViewController: UIViewController {
    // MARK: - UI Elements

    private lazy var collectionViewLayout = HeadlinesScreenCollectionViewLayout(delegate: self)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            FullHeadlinesCell.self,
            forCellWithReuseIdentifier: FullHeadlinesCell.reuseIdentifier
        )
        collectionView.register(
            FullHeadlinesHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FullHeadlinesHeaderView.reuseIdentifier
        )
        collectionView.backgroundColor = .systemTeal
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private var viewModel = HeadlinesScreenViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigation = navigationController as? Navigation {
            navigationItem.titleView = navigation.titleView
        }

        view.backgroundColor = .systemTeal
        setupUI()

        Task {
            await viewModel.fetchSections()
            collectionView.reloadData()
        }
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in

        } completion: { [weak self] _ in
            self?.collectionView.reloadData()
        }

    }
}

extension HeadlinesScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numHeadlines(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let headline = viewModel.headline(for: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headline.cell.reuseIdentifier, for: indexPath)
        let columnWidth = collectionViewLayout.layout.columnWidth(for: indexPath.section, in: collectionView)
        (cell as? HeadlinesCell)?.configure(headlines: headline, columnWidth: columnWidth)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FullHeadlinesHeaderView.reuseIdentifier, for: indexPath)
            let category = viewModel.catgeory(for: indexPath.section)
            (headerView as? FullHeadlinesHeaderView)?.configure(title: category.title, colour: category.colour)
            return headerView
        default:
            fatalError("Invalid supplementary view kind")
        }
    }
}

extension HeadlinesScreenViewController: UICollectionViewDelegate {}
extension HeadlinesScreenViewController: UICollectionViewLayoutDelegate {
    func numberOfSections() -> Int {
        viewModel.numSections()
    }

    func numberOfItemsInSection(section: Int) -> Int {
        viewModel.numHeadlines(for: section)
    }

    func model(for indexPath: IndexPath) -> (any HeadlinesModel)? {
        viewModel.headline(for: indexPath)
    }
}
