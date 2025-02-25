//
//  ButtonOnthKeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/10/24.
//

import UIKit


class ButtonOntheKeyboradVC: UIViewController, UIGestureRecognizerDelegate {
    
    var nsButton = NSLayoutConstraint()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Please Enter"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.addToolBar()
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
        btnButton.shareScreenshotView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.setupKeyboardObservers()
        setupConstraint()
        
        self.hideKeyboardWhenTappedAround()
        //Enable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupConstraint(){
        
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
      
        UIView.actionKeyboardWillShow = { [self] height in
            
            nsButton.constant = -height
            
        }
        
        UIView.actionKeyboardWillHide = { [self] in

            nsButton.constant = -30
        }
    }
}
