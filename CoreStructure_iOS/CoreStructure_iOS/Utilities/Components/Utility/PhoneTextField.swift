//
//  TextFieldPhone.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/3/25.
//

import UIKit

class PhoneTextField: UITextField, UITextFieldDelegate {
    
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
        self.setPadding(left: 15, right: 15)
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




class PhoneTextFieldVC: UIViewController {
    
    var phoneNumberTextField: PhoneTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Phone TextField"
        setupPhoneNumberTextField()
        leftBarButtonItem()
    }
    
    func setupPhoneNumberTextField() {
        // Create a UITextField programmatically
        phoneNumberTextField = PhoneTextField()
        phoneNumberTextField.placeholder = "Enter phone number"
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.keyboardType = .numberPad // Ensure this is set for number input
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.delegate = phoneNumberTextField // Make sure the delegate is set to PhoneNumberTextField
        view.addSubview(phoneNumberTextField)
        

        
        // Set constraints for the phone number text field
        NSLayoutConstraint.activate([
            phoneNumberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneNumberTextField.widthAnchor.constraint(equalToConstant: 250),  // Width of 250 points
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50)   // Height of 50 points
        ])
        
        // Optionally, you can make the text field first responder to test the input
        phoneNumberTextField.becomeFirstResponder()
    }
}
