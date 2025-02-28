//
//  BasicHeadlinesCell.swift
//  NewsApp
//
//  Created by Mike Pollard on 27/02/2025.
//

import UIKit

final class FullHeadlinesCell: UICollectionViewCell {
    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()

    private let backdropView = UIView()
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
            imageView.topAnchor.constraint(equalTo: backdropView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: backdropView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: backdropView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75)
        ])
    }

    // MARK: - Configuration

    func configure(headlines: FullHeadlines) {
        self.headlines = headlines

        textView.attributedText = createAttributedString(title: headlines.title, description: headlines.description)

        let (url, image) = downloadImage(url: headlines.urlToImage)
        if self.headlines?.urlToImage == url {
            imageView.image = image
        }
    }

    private func createAttributedString(title: String, description: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: description,
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
            )
        )

        return attributedText
    }

    private func downloadImage(url: URL) -> (URL, UIImage?) {
        guard let data = try? Data(contentsOf: url) else { return (url, nil) }
        return (url, UIImage(data: data))
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        imageView.image = nil
        textView.attributedText = nil
    }
}
