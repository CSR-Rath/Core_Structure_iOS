//
//  LoginViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 21/2/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    // MARK: - UI Elements
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var createButton: UIButton!
    private var createDBButton: UIButton!
    private var fetchAllProductButton: UIButton!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Firebase"
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        setupTextFields()
        setupButtons()
        setupConstraints()
    }
    
    private func setupTextFields() {
        emailTextField = createTextField(placeholder: "Enter your email", isSecure: false)
        passwordTextField = createTextField(placeholder: "Enter your password", isSecure: true)
    }
    
    private func setupButtons() {
        loginButton = createButton(title: "Log In", action: #selector(loginButtonTapped))
        createButton = createButton(title: "Create Account", action: #selector(createButtonTapped))
        createDBButton = createButton(title: "Create DB", action: #selector(addUserDB))
        fetchAllProductButton = createButton(title: "Fetch Products", action: #selector(fetchAllProducts))
        
        view.addSubview(loginButton)
        view.addSubview(createButton)
        view.addSubview(createDBButton)
        view.addSubview(fetchAllProductButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            createDBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createDBButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20),
            
            fetchAllProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchAllProductButton.topAnchor.constraint(equalTo: createDBButton.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - Button Actions
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Email or password is empty")
            return
        }
        loginUser(email: email, password: password)
    }
    
    @objc private func createButtonTapped() {
        Auth.auth().createUser(withEmail: "test@example.com", password: "123456") { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            print("User created successfully: \(result?.user.email ?? "No email")")
        }
    }

    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                print("Logged in as \(user.email ?? "No email")")
            }
        }
    }
    
    @objc private func addUserDB() {
        let userData: [String: Any] = [
            "name": "John Doe",
            "email": "john@example.com",
            "age": 25
        ]
        
        db.collection("Users").addDocument(data: userData) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                return
            }
            print("User added successfully!")
            self.addProduct()
        }
    }
    
    private func addProduct() {
        let productData: [String: Any] = [
            "name": "iPhone 15",
            "price": 999.99,
            "category": "Smartphone",
            "stock": 50
        ]
        
        db.collection("Products").addDocument(data: productData) { error in
            if let error = error {
                print("Error adding product: \(error.localizedDescription)")
                return
            }
            print("Product added successfully!")
        }
    }
    
    @objc private func fetchAllProducts() {
        db.collection("Products").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach { document in
                let data = document.data()
                let name = data["name"] as? String ?? "Unknown"
                let price = data["price"] as? Double ?? 0.0
                let stock = data["stock"] as? Int ?? 0
                print("Product: \(name), Price: \(price), Stock: \(stock)")
            }
        }
    }

    // MARK: - Helper Methods
    private func createTextField(placeholder: String, isSecure: Bool) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
