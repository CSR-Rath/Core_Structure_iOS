//
//  TextFieldPhone.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/3/25.
//

import UIKit


class BaseUITextFieldPhone: UITextField, UITextFieldDelegate {
    
    var textDidChange: ((_ : String) -> ())?
    var isComplete: ((_ : Bool) -> ())?
    private var strPrefix: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.font = UIFont.boldSystemFont(ofSize: 17)
        self.borderStyle = .none
        self.placeholder = "XXX XXX XXX"
        self.keyboardType = .numberPad
        self.tintColor = .orange
        self.delegate = self  // Ensure delegate is set to self
        self.isPadding(left: 15, right: 15)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("shouldChangeCharactersIn")
        
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        let prefix6Digit = [
            // CellCard
            "11", "12", "14", "17", "61", "77", "78", "85", "89", "92", "95", "99",
            // Smart
            "10", "15", "16", "69", "70", "81", "86", "87", "93", "98",
            // Metfone
            "60", "66", "67", "68", "90",
            // qb
            "13", "80", "83", "84",
            // Excell
            "18"
        ]
        
        // Clean up the string by removing non-numeric characters
        var cleanString = newString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // If the string starts with "0", remove it
        if cleanString.first == "0" {
            cleanString = String(cleanString.dropFirst())
        }
        
        // Get the prefix (first 2 digits) to decide the format
        let strPrefix = String(cleanString.prefix(2))
        
        // Format the phone number based on the prefix
        if prefix6Digit.contains(strPrefix) {
            // Apply format for prefixes that are in the list
            textField.text = formatter(mask: "XX XXX XXX", phoneNumber: cleanString)
        } else {
            // Apply format for other prefixes
            textField.text = formatter(mask: "XX XXX XXX X", phoneNumber: cleanString)
        }
        
        // Check if the phone number is complete (11 or 12 characters)
        let isComplete = textField.text?.count == 11 || textField.text?.count == 12
        self.isComplete?(isComplete)
        
        return false  // Prevent default text change
    }
    
    private func formatter(mask: String, phoneNumber: String) -> String {
        
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result:String = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X"{
                result.append(number[index])
                index = number.index(after: index)
            }else {
                result.append(character)
            }
        }
        
        return result
    }
}




class PhoneTextFieldVC: BaseUIViewConroller {
    
    private  var nsButton = NSLayoutConstraint()
    
    
    lazy var phoneTextField: BaseUITextFieldPhone = {
        let textField = BaseUITextFieldPhone()
        textField.placeholder = "Enter phone number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    lazy var btnButton: BaseUIButton = {
        let button = BaseUIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(didTappedDone), for: .touchUpInside)
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Phone TextField"
        //        leftBarButtonItem(named: .back)
        setupPhoneNumberTextField()
        keyboradHandleer()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneTextField.becomeFirstResponder()
    }
    
    
    @objc private func didTappedDone(){
        print("didTappedDone")
    }
    
    private func keyboradHandleer(){
        
        keyboardManager.onKeyboardWillShow = { [weak self] keyboardHeight in
            guard let self = self else { return }
            self.nsButton.constant = keyboardHeight - 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        keyboardManager.onKeyboardWillHide = { [weak self] in
            guard let self = self else { return }
            self.nsButton.constant = .mainSpacingBottomButton
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupPhoneNumberTextField() {
        // Create a UITextField programmatically
        view.addSubview(btnButton)
        view.addSubview(phoneTextField)
        
        // Set constraints for the phone number text field
        NSLayoutConstraint.activate([
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            phoneTextField.widthAnchor.constraint(equalToConstant: 250),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            btnButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            btnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        nsButton = btnButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .mainSpacingBottomButton)
        nsButton.isActive = true
    }
}
