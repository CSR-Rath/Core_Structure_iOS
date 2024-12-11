//
//  CreateController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//

import UIKit

enum IsRegister{
    case register
    case profile
}

class RegisterController: UIViewController, UIGestureRecognizerDelegate {
    
    let lblTitle = UILabel()
    let lblDescription = UILabel()
    
    let txtFirstName = FloatingLabelTextField()
    let txtLastName = FloatingLabelTextField()
    let txtPhoneNumber = FloatingLabelTextField()
    let txtPassword = FloatingLabelTextField()
    let txtConfimPassword = FloatingLabelTextField()
    let btnRegister = MainButton()
    
    private var textFields : [FloatingLabelTextField] = []
    
    let scroolView = UIScrollView()
    
    var ns = NSLayoutConstraint()
    
    var isRegister : IsRegister = .register
    {
        didSet{
            
            if isRegister ==  .profile{
                lblDescription.isHidden = true
                txtLastName.isHidden = true
                txtFirstName.title = "name"
                
            }else{
                lblTitle.text = "Register"
                txtFirstName.title = "First Name"
               

            }
            
        }
    }

    
    var userInfor : Store = Store(){
        didSet{
            txtFirstName.text = userInfor.name
            txtPhoneNumber.text = userInfor.phoneNumber
            
            txtFirstName.isEnabled = false
            txtPhoneNumber.isEnabled = false
            
            txtPassword.isHidden = true
            txtConfimPassword.isHidden = true
            btnRegister.isHidden = true
            
        }
        
    }
    
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblTitle,
                                                   lblDescription,
                                                   txtFirstName,
                                                   txtLastName,
                                                   txtPhoneNumber,
                                                   txtPassword,
                                                   txtConfimPassword,
                                                   btnRegister,
                                                  ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        stack.setCustomSpacing(25, after: lblTitle)
        stack.setCustomSpacing(50, after: lblDescription)
        stack.setCustomSpacing(25, after: txtConfimPassword)
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if isRegister == .profile{
            leftBarButton()
        }else{
            leftBarButton(tintColor: .mainBlueColor)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        
        textFields = [ txtFirstName, txtLastName, txtPhoneNumber,txtPassword, txtConfimPassword,]
        
        view.backgroundColor = .white
        
        
        lblTitle.fontBold(34)
        
        lblDescription.text = "Thank you for register SS15."
        lblDescription.numberOfLines = 0
        lblDescription.fontRegular(18)
        
        txtLastName.title = "Last Name"
        txtPhoneNumber.title = "Phone Number"
        txtPassword.title = "Password"
        txtConfimPassword.title = "Confim Password"
        
        
        txtPhoneNumber.keyboardType = .numberPad
        txtPassword.keyboardType = .numberPad
        txtConfimPassword.keyboardType = .numberPad
        
        txtPassword.isSecureTextEntry = true
        txtConfimPassword.isSecureTextEntry = true
        
        
        btnRegister.isActionButton = false
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.addTarget(self, action: #selector(didTappedRegister), for: .touchUpInside)
        
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        
        scroolView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroolView)
        scroolView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            scroolView.topAnchor.constraint(equalTo: view.topAnchor),
            scroolView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scroolView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scroolView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stack.topAnchor.constraint(equalTo: scroolView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroolView.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: scroolView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: scroolView.rightAnchor),
            stack.centerXAnchor.constraint(equalTo: scroolView.centerXAnchor),
            
        ])
        
        ns =  scroolView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ns.isActive = true
        
        view.setupKeyboardObservers()
        
        UIView.actionKeyboardWillHide = { [self] in
            ns.constant = 0
            view.layoutIfNeeded()
        }
        UIView.actionKeyboardWillShow = { [self] height in
            ns.constant = -height
            view.layoutIfNeeded()
        }
        
        textFields.forEach({ item in
            item.didEditingChanged = {
                self.checkAvaiableButton()
            }
        })
    }
    
    func checkAvaiableButton(){
        
        var isValidate: Bool = false
        
        textFields.forEach({ item in
            if item.text == ""{
                isValidate = false
            }else{
                isValidate = true
            }
        })
        
        btnRegister.isActionButton = isValidate
    }
    
    
    @objc func didTappedRegister(){
        
        if isRegister == .profile {
            
            if txtPassword.text == txtConfimPassword.text{

                DatabaseManager().saveUserStore(name:  txtFirstName.text ?? "",
                                                password:  txtPassword.text ?? "",
                                                phoneNumber: txtPhoneNumber.text ?? "") {
                    gotoHome()
                } alreadyPhone: {
                    AlertMessage.shared.alertError(title: "Error", message: "Phone number already exists.")
                }
  
            }else{
                AlertMessage.shared.alertError(title: "Error",
                                               message: "The passwords entered do not match.")
            }
            
        }else{
            
            if txtPassword.text == txtConfimPassword.text{
                
                DatabaseManager().saveUser(firstName: txtFirstName.text ?? "",
                                           lastName: txtLastName.text ?? "",
                                           password: txtPassword.text ?? "",
                                           phoneNumber: txtPhoneNumber.text ?? "",
                                           createSuccess:{
                    gotoHome()
                }, alreadyPhone: {
                    AlertMessage.shared.alertError(title: "Error", message: "Phone number already exists.")
                })
                
            }else{
                AlertMessage.shared.alertError(title: "Error",
                                               message: "The passwords entered do not match.")
            }
        }
    }
}


func gotoHome(){
    
    let newVC =  HomeController()
    pushNoback(newVC: newVC)
    UserDefaults.standard.setValue("Merchant", forKey: KeyUser.userType)
    UserDefaults.standard.setValue(true, forKey: KeyUser.loginSuccesFull)
    
}
