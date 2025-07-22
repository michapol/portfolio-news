//
//  HeadlinesScreenCollectionViewLayout.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

protocol UICollectionViewLayoutDelegate: AnyObject {
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func model(for indexPath: IndexPath) -> HeadlinesModel?
}

final class HeadlinesScreenCollectionViewLayout: UICollectionViewLayout {
    unowned private var delegate: UICollectionViewLayoutDelegate

    private var contentSize: CGSize = .zero
    private var headers: [UICollectionViewLayoutAttributes] = []
    private var items: [UICollectionViewLayoutAttributes] = []

    lazy var layout = getLayout()

    init(delegate: UICollectionViewLayoutDelegate) {
        self.delegate = delegate

        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeadlinesScreenCollectionViewLayout {
    override var collectionViewContentSize: CGSize { contentSize }

    override func prepare() {
        guard let collectionView else { return }

        contentSize = .zero
        items.removeAll(keepingCapacity: true)
        headers.removeAll(keepingCapacity: true)
        layout = getLayout()

        var yPositions = [Double]()
        var xPositions = [Double]()

        for section in (0..<delegate.numberOfSections()) {
            if delegate.numberOfItemsInSection(section: section) > 0 {
                setupColumns(for: section, in: collectionView, xPositions: &xPositions, yPositions: &yPositions)
                setupHeader(for: section, in: collectionView, yPositions: &yPositions)
            }

            for item in (0..<delegate.numberOfItemsInSection(section: section)) {
                let indexPath = IndexPath(item: item, section: section)
                guard let model = delegate.model(for: indexPath) else { break }

                let currentColumn = yPositions.firstIndex(of: yPositions.min() ?? 0.0) ?? 0

                yPositions[currentColumn] += layout.itemInsets(for: item).top

                let columnWidth = layout.columnWidth(for: section, in: collectionView)
                let size = FullHeadlinesCell.size(headlines: model, columnWidth: columnWidth)
                let position = CGPoint(x: xPositions[currentColumn], y: yPositions[currentColumn])

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: position, size: size)
                items.append(attributes)

                yPositions[currentColumn] += size.height
                yPositions[currentColumn] += layout.itemInsets(for: item).bottom
            }
            updateSize(for: section, in: collectionView, yPositions: &yPositions)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        items.filter { $0.frame.intersects(rect) } + headers.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        items.first { $0.indexPath == indexPath }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        headers.first { $0.indexPath == indexPath }
    }

    private func setupColumns(
        for section: Int,
        in collectionView: UICollectionView,
        xPositions: inout [Double],
        yPositions: inout [Double]
    ) {
        xPositions.removeAll()
        yPositions.removeAll()

        for column in 1...layout.columns(for: section) {
            let itemInsets = layout.itemInsets(for: section)
            let columnWidth = layout.columnWidth(for: section, in: collectionView)

            let currentOffset = (itemInsets.left * Double(column)) + (columnWidth * Double(column - 1))
            xPositions.append(currentOffset)
            yPositions.append(contentSize.height + layout.sectionPadding(for: section).top)
        }
    }

    private func setupHeader(
        for section: Int,
        in collectionView: UICollectionView,
        yPositions: inout [Double]
    ) {
        let headerWidth = layout.columnWidth(for: section, in: collectionView)
        let size = CGSize(width: headerWidth, height: 64.0)
        let position = CGPoint(x: layout.sectionPadding(for: section).left, y: yPositions[0])

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
        attributes.frame = CGRect(origin: position, size: size)
        headers.append(attributes)

        for column in 0..<layout.columns(for: section) {
            yPositions[column] += size.height
            yPositions[column] += layout.sectionPadding(for: section).bottom
        }
    }

    private func updateSize(
        for section: Int,
        in collectionView: UICollectionView,
        yPositions: inout [Double]
    ) {
        let maxY = (yPositions.max() ?? 0) + layout.sectionPadding(for: section).bottom
        contentSize = CGSize(width: collectionView.bounds.width, height: maxY)
    }
}

extension HeadlinesScreenCollectionViewLayout {
    struct Layout {
        static let singleColumn: Self = .init(columns: 1)

        let columns: Int

        func columns(for section: Int) -> Int {
            self.columns
        }

        func columnWidth(for section: Int, in collectionView: UICollectionView) -> Double {
            let collectionViewWidth = collectionView.bounds.width
            let columns = Double(columns(for: section))
            let sectionPadding = horizontalSectionPadding(for: section)
            let itemInsets = horizontalItemInsets(for: section)

            let sectionWidth = collectionViewWidth - sectionPadding
            let columnInsets = (columns - 1) * itemInsets

            return (sectionWidth - columnInsets) / columns
        }

        func itemInsets(for section: Int) -> UIEdgeInsets {
            switch self.columns {
            case 1:
                return .init(top: 0.0, left: 0.0, bottom: 8.0, right: 0.0)
            default:
                return .init(top: 0.0, left: 8.0, bottom: 8.0, right: 0.0)
            }
        }

        func horizontalItemInsets(for section: Int) -> CGFloat {
            let insets = itemInsets(for: section)
            return insets.left + insets.right
        }

        func sectionPadding(for section: Int) -> UIEdgeInsets {
            switch self.columns {
            case 1:
                return .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            default:
                return .init(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            }
        }

        func horizontalSectionPadding(for section: Int) -> CGFloat {
            let padding = sectionPadding(for: section)
            return padding.left + padding.right
        }
    }

    private func getLayout() -> Layout {
        guard let windowSize = windowSize else { return .singleColumn }

        let minimumColumnWidth = ProcessInfo.processInfo.isiOSAppOnMac ? 500.0 : 350.0

        let columns = Int(windowSize.width / minimumColumnWidth)
        return Layout(columns: columns)
    }

    private var windowSize: CGSize? {
        UIApplication.shared.connectedScenes
                        .compactMap({ scene -> UIWindow? in
                            (scene as? UIWindowScene)?.keyWindow
                        })
                        .first?
                        .frame
                        .size
    }
}
