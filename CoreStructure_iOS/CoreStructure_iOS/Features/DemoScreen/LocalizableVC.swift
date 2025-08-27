//
//  LocalizableContoller.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 7/11/24.
//

import UIKit



class LocalizableVC: BaseUIViewConroller {
    
    let keyLocalizable : [String] = [
        "customer",
        "first_name",
        "last_name",
        "welcome_message",
        "goodbye_message",
        "error_message"
    ]
    
    var isKhmerLanguage: Bool = false
    private var textFields : [FloatingLabelTextField] = []
    
    lazy var btnSwitchLang: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setTitle("Switch", for: .normal)
        btn.addTarget(self, action:  #selector(didSwitch), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblWelcome: UILabel = {
        let lbl = UILabel()
        lbl.fontRegular(17,color: .black)
        return lbl
    }()
    
    lazy var lblGoodBye: UILabel = {
        let lbl = UILabel()
        lbl.fontRegular(17,color: .black)
        return lbl
    }()
    
    
    lazy var textField1: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.isRequiredStar()
        return textField
    }()
    
    lazy var textField2: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.changeIconRight(icon: .iconEmpty)
        return textField
    }()
    
    lazy var textField3: FloatingLabelTextField = {
        let textField = FloatingLabelTextField()
        textField.isOptionalTextField()
        textField.changeIconRight(icon: .iconDdate)
        return textField
    }()
    
    lazy var stackContainer: UIStackView = {
        let stack  = UIStackView(arrangedSubviews: [textField1,
                                                    textField2,
                                                    textField3,
                                                    lblWelcome,
                                                    lblGoodBye,
                                                    btnSwitchLang])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        title = "Localizable"
        textFields = [textField1,textField2,textField3]
        setupConstraint()
        reloadLabel()
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
        
        LanguageManager.shared.setCurrentLanguage(isKhmerLanguage ? .khmer : .english)

        
        print("isKhmerLanguage \(isKhmerLanguage)")
        
        reloadLabel()
    }
    
    
    private func reloadLabel(){
        
        for (index, element) in  keyLocalizable.enumerated(){
            
            print("index: \(index) ==> \(element.localizeString())")
            
            if index < 3{
                textFields[index].text = element.localizeString()
            }else if index == 3{
                lblWelcome.text =  element.localizeString()
            }else if  index == 4{
                lblGoodBye.text =  element.localizeString()
            }
        }
    }
}



