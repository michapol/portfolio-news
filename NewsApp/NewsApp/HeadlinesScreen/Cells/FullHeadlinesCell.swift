//
//  BasicHeadlinesCell.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

protocol HeadlinesCell {
    static var reuseIdentifier: String { get }

    func configure(headlines: HeadlinesModel, columnWidth: CGFloat)
}

extension HeadlinesCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

final class FullHeadlinesCell: UICollectionViewCell, HeadlinesCell {
    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = Self.textViewInsets
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .white
        return textView
    }()

    private let backdropView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private var headlines: FullHeadlines?

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        contentView.addSubview(backdropView)
        backdropView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backdropView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        backdropView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: backdropView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: backdropView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: backdropView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: backdropView.trailingAnchor)
        ])

        backdropView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: backdropView.topAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: backdropView.trailingAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalTo: backdropView.widthAnchor, multiplier: Self.imageWidthRatio),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Self.imageHeightRatio)
        ])
    }

    // MARK: - Configuration

    func configure(headlines: HeadlinesModel, columnWidth: CGFloat) {
        guard let headlines = headlines as? FullHeadlines else { return }
        self.headlines = headlines

        textView.attributedText = Self.createAttributedString(title: headlines.title, description: headlines.description)

        if let urlToImage = headlines.urlToImage {
            let textWidth = columnWidth - (Self.textViewInsets.left + Self.textViewInsets.right)
            textView.textContainer.exclusionPaths = [Self.imageExclusionPath(width: textWidth)]
            Task {
                await setImage(urlToImage: urlToImage, columnWidth: columnWidth)
            }
        } else {
            noImage()
        }
    }

    private func setImage(urlToImage: URL, columnWidth: CGFloat) async {
        do {
            let (url, image) = try await downloadImage(url: urlToImage)

            guard let headlines = self.headlines, headlines.urlToImage == url else { return }

            imageView.image = image ?? UIImage(resource: .placeholder)
        } catch {
            imageView.image = UIImage(resource: .placeholder)
        }
    }

    private func noImage() {
        imageView.isHidden = true
        textView.textContainer.exclusionPaths = []
    }

    private func downloadImage(url: URL) async throws -> (URL, UIImage?) {
        let (data, _) = try await URLSession.shared.data(from: url)
        return (url, UIImage(data: data))
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        imageView.image = nil
        imageView.isHidden = false
        textView.attributedText = nil
    }
}

protocol CellSize {
    static func size(headlines: HeadlinesModel, columnWidth: CGFloat) -> CGSize
}

extension FullHeadlinesCell: CellSize {
    private static let imageWidthRatio = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.35
    private static let imageHeightRatio = UIDevice.current.userInterfaceIdiom == .pad ? 0.75 : 0.575
    private static let textViewInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    static func size(headlines: HeadlinesModel, columnWidth: CGFloat) -> CGSize {
        CGSize(
            width: columnWidth,
            height: cellHeight(headlines: headlines, columnWidth: columnWidth)
        )
    }

    private static func cellHeight(headlines: HeadlinesModel, columnWidth: CGFloat) -> CGFloat {
        guard let headlines = headlines as? FullHeadlines else { return 0 }

        let width = columnWidth - (textViewInsets.left + textViewInsets.right)
        let attributedString = createAttributedString(title: headlines.title, description: headlines.description)
        let textHeight = heightOf(attributedString: attributedString, withImage: headlines.urlToImage != nil, width: width)
        return textHeight + textViewInsets.top + textViewInsets.bottom
    }

    private static func createAttributedString(title: String, description: String?) -> NSAttributedString {
        let justifiedParagraphStyle = NSMutableParagraphStyle()
        justifiedParagraphStyle.alignment = .justified

        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold),
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.paragraphStyle: justifiedParagraphStyle
            ]
        )

        guard let description else { return attributedText }

        attributedText.append(
            NSAttributedString(
                string: "\n\n",
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 6, weight: .regular),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
            )
        )

        attributedText.append(
            NSAttributedString(
                string: description,
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular),
                    NSAttributedString.Key.foregroundColor : UIColor.black,
                    NSAttributedString.Key.paragraphStyle: justifiedParagraphStyle
                ]
            )
        )

        return attributedText
    }

    private static func heightOf(attributedString: NSAttributedString, withImage: Bool, width: CGFloat) -> CGFloat {
        let imageExclusionPath = imageExclusionPath(width: width)
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.exclusionPaths = withImage ? [imageExclusionPath] : []

        let textLayoutManager = NSTextLayoutManager()
        textLayoutManager.textContainer = textContainer

        let textContentStorage = NSTextContentStorage()
        textContentStorage.attributedString = attributedString
        textContentStorage.addTextLayoutManager(textLayoutManager)

        textLayoutManager.ensureLayout(for: textLayoutManager.documentRange)

        let rect = textLayoutManager.usageBoundsForTextContainer
        return max(rect.size.height.rounded(.up), withImage ? imageExclusionPath.bounds.height + 8.0 : 0.0)
    }

    private static func imageExclusionPath(width: CGFloat) -> UIBezierPath {
        UIBezierPath(rect: CGRect(
            x: (width * (1.0 - imageWidthRatio)) - 16.0,
            y: 8.0,
            width: (width * imageWidthRatio) + 16.0,
            height: width * imageWidthRatio * imageHeightRatio
        ))
    }
}
