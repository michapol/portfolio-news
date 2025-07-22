//
//  FullHeadlinesHeaderView.swift
//  NewsApp
//
//  Created by Mike Pollard on 06/03/2025.
//

import UIKit

final class FullHeadlinesHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String { String(describing: Self.self) }

    // MARK: - UI Elements

    private let colouredBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0, weight: .black)
        label.textColor = .white
        return label
    }()

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(colouredBar)
        colouredBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colouredBar.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            colouredBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            colouredBar.heightAnchor.constraint(equalToConstant: 8.0),
            colouredBar.widthAnchor.constraint(equalToConstant: 75.0)
        ])

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: colouredBar.bottomAnchor, constant: 4.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0)
        ])
    }

    override func prepareForReuse() {
        colouredBar.backgroundColor = .black
        titleLabel.text = nil
    }

    // MARK: - Configure

    func configure(title: String, colour: UIColor) {
        colouredBar.backgroundColor = colour
        titleLabel.text = title.uppercased()
    }
}
