//
//  ButtonOnthKeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/10/24.
//

import UIKit


class ButtonOntheKeyboradVC: BaseInteractionController{
    
    private  var nsButton = NSLayoutConstraint()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Please Enter"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = view.createTooBar()
        return textField
    }()
    
    lazy var btnButton: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(didTappedDone), for: .touchUpInside)
        return btn
    }()
    
    @objc func didTappedDone(){
        btnButton.shareViewScreenshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Testing Keyborad"
        view.backgroundColor = .white
        setupConstraint()
        keyboradHandleer()
    }
    
    private func keyboradHandleer(){
        
        keyboardManager.onKeyboardWillShow = { keyboardHeight in
            
            self.nsButton.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
        
        keyboardManager.onKeyboardWillHide = { _ in
            self.nsButton.constant = -30
            self.view.layoutIfNeeded()

        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.dismissKeyboard()
    }
    
    private func setupConstraint(){
        
        view.createBarAppearanceView(color: .orange)
        view.addSubview(textField)
        view.addSubview(btnButton)
        
        NSLayoutConstraint.activate([
            
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -50),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 50),
        
            btnButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            btnButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            btnButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30),
        ])
        

        nsButton = btnButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30)
        nsButton.isActive = true
    }
}
