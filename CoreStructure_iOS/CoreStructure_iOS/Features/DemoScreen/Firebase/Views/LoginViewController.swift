
import UIKit

class LoginViewController: UIViewController {
    
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
        let username = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.login(username: username, password: password)
        viewModel.onSuccessLogin = {
            let vc = CallMultipleApiTheSameThie()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

class CallMultipleApiTheSameThie: UIViewController{
    
    let viewModel = CallMultipleApiTheSameThieViewModel()
    
    private let btnCallApi: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setTitle("Call API", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Touch me"
        
        view.addSubview(btnCallApi)
        
        btnCallApi.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnCallApi.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
        btnCallApi.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        
        btnCallApi.actionUIButton = {
            
            
            let viewModel = CallMultipleApiTheSameThieViewModel()
            viewModel.fetchApiTheSameTime()
            
        }
        
    }
    
    
//   @objc private func TappedCallAPI(){
//  
//        viewModel.onDataUpdated = {
//        
//        }
//    }
    
  
}

class CallMultipleApiTheSameThieViewModel{

    var productList1: ProductListResponse?
    var productList2: ProductListResponse?
    var productList3: ProductListResponse?
    
    var onDataUpdated: (() -> Void)?
    
    func fetchApiTheSameTime() {
        let group = DispatchGroup() // iOS 8+ DispatchGroup -> iOS 15+  withTaskGroup
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products1) { (res: ProductListResponse) in
            DispatchQueue.main.async { [self] in
                self.productList1 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products2) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList2 = res
            }
            group.leave()
        }
        
        group.enter()
        ApiManager.shared.apiConnection(url: .products3) { (res: ProductListResponse) in
            DispatchQueue.main.async {
                self.productList3 = res
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.onDataUpdated?()
            print("✅ All APIs completed")
        }
    }
    
}


import Foundation

// Top-level response for paginated products
struct ProductListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Product]
}

// Single product model
struct Product: Codable {
    let id: Int
    let name: String
    let price: String
    let createdAt: String
    let createdBy: Int

    // Map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}



class LoginViewModel{
    
    var onSuccessLogin: (()->Void)?
    
    func login(username: String, password: String){
        
        let modelCodable = ParamLogin(username: username,
                               password: password)
        
        ApiManager.shared.apiConnection(url: .login,
                                        method: .POST,
                                        modelCodable: modelCodable) { (res: LoginModel) in
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(res.access, forKey: AppConstants.token)
                UserDefaults.standard.setValue(res.refresh, forKey: AppConstants.refreshToken)
                UserDefaults.standard.setValue(true, forKey: AppConstants.loginSuuccess)
                self.onSuccessLogin?()
            }
        }
    }
}

struct ParamLogin: Codable{
    let username: String
    let password: String
}

struct LoginModel: Codable{
    let refresh: String
    let access: String
}
