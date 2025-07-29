//
//  LoginScreenVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/6/25.
//

import UIKit

//MARK: - ViewController
class LoginScreenVC: UIViewController {
    
    let viewModel = LoginViewModel()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let loginButton: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setTitle("Login", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
        ])
    }
    
    @objc private func loginTapped() {
        
        loginButton.startLoading()
        
        let username = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.login(username: username, password: password)
        
        viewModel.onSuccessLogin = { [weak self] in
            self?.loginButton.stopLoading()
            SceneDelegate.changeRootViewController(to: CustomTabBarVC())
        }
    }
}

//@MainActor
class LoginViewModel{
    
    var onSuccessLogin: (()->Void)?
    
    func login(username: String, password: String){
        
        let modelCodable = ParamLogin(username: username,
                                      password: password)
        
        ApiManager.shared.apiConnection(url: .login,
                                        method: .POST,
                                        modelCodable: modelCodable) { (res: LoginModel) in
//            DispatchQueue.main.async {
                UserDefaults.standard.setValue(res.access, forKey: AppConstants.token)
                UserDefaults.standard.setValue(res.refresh, forKey: AppConstants.refreshToken)
                UserDefaults.standard.setValue(true, forKey: AppConstants.loginSuuccess)
                self.onSuccessLogin?()
//            }
        }
    }
}

//MARK: - Model
struct ParamLogin: Codable{
    let username: String
    let password: String
}


