//
//  LocalizableContoller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import UIKit

class LocalizableContoller: UIViewController {
    
    var isKhmerLanguage: Bool = false
    private var textFields : [FloatingLabelTextField] = []
    
    lazy var btnSwitchLang: MainButton = {
        let btn = MainButton()
        btn.setTitle("Switch", for: .normal)
        btn.addTapGesture(target: self, action: #selector(didSwitch))
        return btn
    }()
    
    lazy var lblWelcome: UILabel = {
        let lbl = UILabel()
        lbl.fontRegular(17)
        return lbl
    }()
    
    lazy var lblGoodBye: UILabel = {
        let lbl = UILabel()
        lbl.fontRegular(17)
        return lbl
    }()
    
    lazy var lblError: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    lazy var textField: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.isRequiredStar()
        textField.title = "Customer"
        return textField
    }()
    
    lazy var textField2: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.title = "First Name"
        textField.changeIconRight(icon: .iconEmpty)
        return textField
    }()
    
    lazy var textField3: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.title = "Last Name"
        textField.isOptionalTextField()
        textField.changeIconRight(icon: .iconDdate)
        return textField
    }()
    
    lazy var stackContainer: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [ textField,textField2,textField3,lblWelcome,lblGoodBye,lblError,btnSwitchLang])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let wellcon: String = "welcome_message".localizeString()
        let bye: String = "goodbye_message".localizeString()
        print("welcome_message", wellcon)
        print("goodbye_message",bye)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFields.forEach({ item in
            
            item.resignFirstResponder()
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        reloadLabel()
        
        textFields = [textField,textField2,textField3]
    }
    
    private func setupConstraint(){
        view.addSubview(stackContainer)
        NSLayoutConstraint.activate([
            stackContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    
    @objc private func didSwitch(){
        isKhmerLanguage.toggle()
        setLanguage(langCode: isKhmerLanguage ?  "km" : "en")
        
        print("isKhmerLanguage \(isKhmerLanguage)")
        
        reloadLabel()
    }
    
    
    private func reloadLabel(){
        
        lblGoodBye.text = "goodbye_message".localizeString()
        lblWelcome.text = "welcome_message".localizeString()
        lblError.text = "error_message".localizeString()
        textField.resignFirstResponder()
        
        
        // Setup when touch begin textfields
        textFields.forEach({ item in
            item.didEditingDidBegin = { [self] in
                stackContainer.setCustomSpacing(15, after: item)
            }
        })
        
        
        view.isValidateTextField(textFields: textFields) { [self] success in
            
            stackContainer.setCustomSpacing(15, after: success)
            
        } failure: { [self] failure in
            
            stackContainer.setCustomSpacing(30, after: failure)
            
        }
    }
}



