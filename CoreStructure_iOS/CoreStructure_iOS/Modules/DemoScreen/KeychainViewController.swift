//
//  KeychainViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 5/5/25.
//

import UIKit

class KeychainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }
    
    private func setupButtons() {
        let saveButton = createButton(title: "Save Token", action: #selector(saveTapped))
        let readButton = createButton(title: "Read Token", action: #selector(readTapped))
        let deleteButton = createButton(title: "Delete Token", action: #selector(deleteTapped))
        
        let stackView = UIStackView(arrangedSubviews: [saveButton, readButton, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            readButton.widthAnchor.constraint(equalToConstant: 200),
            deleteButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func saveTapped() {
        let result = KeychainManager.save(key: "userToken", value: "abc123")
        print("Save result:", result)
    }
    
    @objc private func readTapped() {
        if let token = KeychainManager.read(key: "userToken") {
            print("Token:", token)
        } else {
            print("No token found.")
        }
    }
    
    @objc private func deleteTapped() {
        let result = KeychainManager.delete(key: "userToken")
        print("Delete result:", result)
    }
    
}

