//
//  LoginController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//

import UIKit

enum UserTypeEnum: String{
    case store = "Store"
    case merchant = "Merchant"
}

class LoginController: UIViewController, UIGestureRecognizerDelegate {
    
    let txtEmail = FloatingLabelTextField()
    let btxtPassword = FloatingLabelTextField()
    let btnLogin = MainButton()
    let lblTitle = UILabel()
    var textFields :[FloatingLabelTextField] = []
    
    let btnForget = MainButtonOnSetHeigth()
    
    var ns = NSLayoutConstraint()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblTitle, txtEmail, btxtPassword, btnLogin])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .fill
        stack.setCustomSpacing(50, after: lblTitle)
        stack.setCustomSpacing(30, after: btxtPassword)
        return stack
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.merchant.rawValue{
            lblTitle.text = "Login As Merchant"
        }else{
            lblTitle.text = "Login As Store"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftBarButton(tintColor: .mainBlueColor)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func teppedButton(){
        let user = DatabaseManager().fetchUser()
        let userStore = DatabaseManager().fetchUserSore()
        

        
        if  UserDefaults.standard.string(forKey: KeyUser.userType) == UserTypeEnum.merchant.rawValue{
            
            if user.count > 0{
                for item in user {
                    if item.phoneNumber == txtEmail.text{
                        if item.password == btxtPassword.text{
                            let newVC =  HomeController()
                            pushNoback(newVC: newVC)
                            UserDefaults.standard.setValue(true, forKey: KeyUser.loginSuccesFull)
                            break
                        }else{
                            AlertMessage.shared.alertError(title: "Message", message: "Invalid password. Please try again.")
                        }
                    }else{
                        AlertMessage.shared.alertError(title: "Message", message: "Phone number not yet register.")
                    }
                }
            }else{
                AlertMessage.shared.alertError(title: "Message", message: "Phone number not yet register.")
            }
        }else{
            if userStore.count > 0 {
                
                for item in userStore {
                    if item.phoneNumber == txtEmail.text{
                        if item.password == btxtPassword.text{
                            let newVC =  HomeController()
                            pushNoback(newVC: newVC)
                            UserDefaults.standard.setValue(true, forKey: KeyUser.loginSuccesFull)
                            break
                        }else{
                            AlertMessage.shared.alertError(title: "Message", message: "Invalid password. Please try again.")
                        }
                    }else{
                        AlertMessage.shared.alertError(title: "Message", message: "Phone number not yet register.")
                    }
                }
                
            }else{
                AlertMessage.shared.alertError(title: "Message", message: "Phone number not yet register.")
            }
        }
        
    }
    
    
    private func setupUI(){
        textFields = [txtEmail , btxtPassword]
        
        
        lblTitle.textColor = .mainBlueColor
        lblTitle.fontMedium(24)
        
        txtEmail.title = "Phone Number"
        btxtPassword.title = "Password"
        txtEmail.keyboardType = .numberPad
        btxtPassword.keyboardType = .numberPad
        btxtPassword.isSecureTextEntry = true
        
        btnLogin.isActionButton = false
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.addTargetButton(target: self, action: #selector(teppedButton))
        
        btnForget.translatesAutoresizingMaskIntoConstraints = false
        btnForget.setTitle("forget", for: .normal)
        btnForget.setTitleColor(.red, for: .normal)
        btnForget.layer.cornerRadius = 0
        btnForget.backgroundColor = .clear
        btnForget.addTargetButton(target: self, action: #selector(didTappedForget))
        
        view.addSubview(stack)
        view.addSubview(btnForget)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -150),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            btnForget.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 20),
            btnForget.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        textFields.forEach({ item in
            item.didEditingChanged  = { [self] in
                checkAvaiableButton(button: btnLogin, textFields: textFields)
            }
        })
    }
    
    
   @objc func didTappedForget(){
       
//       let otp = OTPVC()
//       otp.btnClear.isHidden = true
//       self.navigationController?.pushViewController(otp, animated: true)
        
    }
    
}



func checkAvaiableButton(button: MainButton, textFields: [FloatingLabelTextField]){
    
    var isValidate: Bool = false
    
    textFields.forEach({ item in
        if item.text == ""{
            isValidate = false
        }else{
            isValidate = true
        }
    })
    
    button.isActionButton = isValidate
}
