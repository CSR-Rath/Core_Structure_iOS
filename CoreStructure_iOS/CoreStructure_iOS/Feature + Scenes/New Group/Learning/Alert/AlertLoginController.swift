//
//  AlertLoginController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

class AlertLoginController: UIViewController {
    
    var didTappedButon: ((Int)->())?
    
    let containerView = UIView()
    let btnStore = MainButton()
    let btnMerchant = MainButton()
    let lblLogin = UILabel()
    let lblDescription = UILabel()
    let btnClose = MainButtonOnSetHeigth()
    
    lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblLogin,lblDescription,btnMerchant,btnStore])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        stack.layoutMargins = UIEdgeInsets(top: 35, left: 0, bottom: 30, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(19, after: lblLogin)
        stack.setCustomSpacing(50, after: lblDescription)
        return stack
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func didTapped(_ sender : UIButton){
        
        if sender.tag == 1 {
            UserDefaults.standard.setValue(UserTypeEnum.merchant.rawValue, forKey: KeyUser.userType)
        }else{
            UserDefaults.standard.setValue(UserTypeEnum.store.rawValue, forKey: KeyUser.userType)
        }
        
        didTappedButon?(sender.tag)
        
    }
    
    
    private func setupUI(){
        
        lblLogin.text = "Login"
        lblLogin.textAlignment = .center
        lblLogin.textColor = .mainBlueColor
        lblLogin.fontMedium(24)
        
        lblDescription.text = "Please choose the login method you prefer."
        lblDescription.numberOfLines = 0
        lblDescription.textAlignment = .center
        lblDescription.fontRegular(18)
        lblDescription.textColor = .mainBlueColor
        
        btnStore.tag = 0
        btnStore.setTitle("Login As Store", for: .normal)
        btnStore.addTargetButton(target: self, action: #selector(didTapped))
        btnMerchant.tag = 1
        btnMerchant.setTitle("Login As Merchant", for: .normal)
        btnMerchant.addTargetButton(target: self, action: #selector(didTapped))
        
        containerView.addTapGesture(target: self, action: #selector(touchHelper))
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(stack)
        
        
        btnClose.setTitle("Close", for: .normal)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.layer.cornerRadius = 35
        btnClose.backgroundColor = .red
        btnClose.layer.borderWidth = 3
        btnClose.layer.borderColor = UIColor.white.cgColor
        btnClose.addTargetButton(target: self, action: #selector(touchDismiss))
        view.addSubview(btnClose)
        
        
        NSLayoutConstraint.activate([
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            stack.topAnchor.constraint(equalTo: containerView.topAnchor),
            stack.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 20),
            stack.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -20),
            
            btnClose.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            btnClose.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            btnClose.heightAnchor.constraint(equalToConstant: 70),
            btnClose.widthAnchor.constraint(equalToConstant: 70),
            
        ])
        
    }
    
    @objc func touchHelper(){
        
    }
    
}
