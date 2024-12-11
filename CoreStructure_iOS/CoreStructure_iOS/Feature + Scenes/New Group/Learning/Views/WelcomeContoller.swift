//
//  WelcomeContoller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/11/24.
//

import UIKit

class WelcomeContoller: UIViewController {
    
    let lblTitle = UILabel()
    let lblDescription = UILabel()
    
    let btnLogin = MainButton()
    let btnCreate = MainButton()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblTitle,
                                                   lblDescription,
                                                   btnLogin,
                                                   btnCreate])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.setCustomSpacing(25, after: lblTitle)
        stack.setCustomSpacing(100, after: lblDescription)
        
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.setValue(false, forKey: KeyUser.loginSuccesFull)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI(){
        lblTitle.text = "Welcome"
        lblTitle.fontBold(34)
        lblDescription.text = "Thank you for choosing SS15.\nLet’s embark on this journey together!"
        lblDescription.numberOfLines = 0
        lblDescription.fontRegular(18)
        
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.tag = 0
        btnCreate.setTitle("Register", for: .normal)
        btnCreate.tag = 1
        //--
        btnLogin.addTargetButton(target: self, action: #selector(didTappedButton))
        btnCreate.addTargetButton(target: self, action: #selector(didTappedButton))
        
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
        ])
        
    }
    
    
    @objc private func didTappedButton(sender: UIButton){
        
        if sender.tag == 0 {
            
            let vc = AlertLoginController()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = presentVC
            self.present(vc, animated: true)
            
            vc.didTappedButon = { tage in
                
                vc.dismiss(animated: true) {
                    let vc = LoginController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }else{
            let vc = RegisterController()
            vc.isRegister = .register
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
