//
//  SplashScreenViewController.swift
//  NewsApp
//
//  Created by Mike Pollard on 26/02/2025.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    // MARK: - UI Elements

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " headlines ".uppercased()
        label.textColor = .white
        label.font = .systemFont(ofSize: 72.0, weight: .black)
        label.layer.cornerRadius = 8.0
        label.layer.borderWidth = 3.0
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .init(width: 3.0, height: 3.0)
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shouldRasterize = true
        return label
    }()

    let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Downloading Headlines..."
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .black)
        label.alpha = 0
        return label
    }()

    // MARK: - Properties

    private var viewModel: SplashScreenViewModelProtocol

    // MARK: - Lifecycle

    init(viewModel: SplashScreenViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.viewModel.errorHandler = errorHandler
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        Task { await viewModel.screenAppeared() }

        UIView.animate(withDuration: 0.5, delay: 0.5) { [weak progressLabel] in
            progressLabel?.alpha = 1
        }
    }

    private func setupView() {
        view.backgroundColor = .systemTeal

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        titleLabel.transform = CGAffineTransform(rotationAngle: .pi / 3.5)

        view.addSubview(progressLabel)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            progressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            progressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
    }

    // MARK: - Error Callback

    func errorHandler(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: "The application failed to load", preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                Task { await self?.viewModel.screenAppeared() }
            }
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
}
