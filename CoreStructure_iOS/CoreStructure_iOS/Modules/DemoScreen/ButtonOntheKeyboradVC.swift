//
//  ButtonOnthKeyboradVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/10/24.
//

import UIKit


class ButtonOntheKeyboradVC: UIViewController, UIGestureRecognizerDelegate {
    
    private  var nsButton = NSLayoutConstraint()
  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarAppearance(titleColor: .clear, barColor: .clear)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
    }
    
    private func keyboradHandleer(){
        
        keyboardHandler.onKeyboardWillShow = { keyboardHeight in
            // add animation
            UIView.animate(withDuration: 0.5, delay: 0.25, // Use a non-zero duration
                           options: .curveEaseIn,
                           animations: {
                self.nsButton.constant = keyboardHeight
                self.view.layoutIfNeeded()
            })
        }
        
        keyboardHandler.onKeyboardWillHide = {
            self.nsButton.constant = -30
            self.view.layoutIfNeeded()
        }
        
        view.addGestureView(target: self, action: #selector(dismissKeyboard))
    }
    
    private func setupConstraint(){
        
        view.setupBarAppearanceView(color: .orange)
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
