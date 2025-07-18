//
//  CreateDBFeribaseViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 21/2/25.
//

import UIKit

class CreateDBFeribaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}



import UIKit

class ViewController: UIViewController {
    
    private let checkStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Network Status", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(checkStatusButton)
        
        NSLayoutConstraint.activate([
            checkStatusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkStatusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkStatusButton.widthAnchor.constraint(equalToConstant: 250),
            checkStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        checkStatusButton.addTarget(self, action: #selector(checkNetworkStatus), for: .touchUpInside)
    }
    
    @objc private func checkNetworkStatus() {
        print("Button tapped") // Debugging
        
//        let isConnected = NetworkMonitor.shared.isConnected
//        let connectionType = NetworkMonitor.shared.connectionType
        
//        var message = isConnected ? "Connected" : "No Internet Connection"
//        
//        if isConnected {
//            switch connectionType {
//            case .wifi:
//                message = "Connected via Wi-Fi"
//            case .cellular:
//                message = "Connected via Cellular"
//            case .wiredEthernet:
//                message = "Connected via Ethernet"
//            default:
//                message = "Unknown Network Connection"
//            }
//        }
        
//        print("message : \(message)")
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
