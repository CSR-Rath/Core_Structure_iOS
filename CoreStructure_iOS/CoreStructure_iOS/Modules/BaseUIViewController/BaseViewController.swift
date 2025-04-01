//
//  BaseViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 17/3/25.
//
import UIKit

// MARK: - BaseViewController
class BaseViewController: UIViewController {

    // MARK: - Properties
    var isBackBarItemButton: Bool = true

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
//        setupActions()
    }
    
    // MARK: - Setup Methods
    func setupUI() {
        view.backgroundColor = .white
        if isBackBarItemButton {
            setupBackButton()
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func setupConstraints() {
        // To be overridden by subclasses
    }
    
//    func setupActions() {
//        // To be overridden by subclasses
//    }
    
    // MARK: - Helper Methods
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }

    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Example Usage
class HomeViewController: BaseViewController {
    private let welcomeLabel = UILabel()

    override func setupUI() {
        super.setupUI()
        welcomeLabel.text = "Welcome to Home"
        welcomeLabel.textColor = .darkGray
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(welcomeLabel)
    }
    
    override func setupConstraints() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

