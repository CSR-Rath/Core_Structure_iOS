//
//  CreateController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/12/24.
//

import UIKit

enum UIType {
    case update
    case create
}

class GeustController: UIViewController {

    var isUIType : UIType = .create
    var geustID: Int = 0
    
    // MARK: - Properties
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let phoneTextField = UITextField()
    private let addressTextField = UITextField()
    private let submitButton =  MainButton()
    private let messageLabel = UILabel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBarButton()
        setupUI()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Add Guest"
        
        // Configure Text Fields
        setupTextField(firstNameTextField, placeholder: "First Name")
        setupTextField(lastNameTextField, placeholder: "Last Name")
        setupTextField(emailTextField, placeholder: "Email")
        emailTextField.keyboardType = .emailAddress
        setupTextField(phoneTextField, placeholder: "Phone")
        phoneTextField.keyboardType = .phonePad
        setupTextField(addressTextField, placeholder: "Address")
        
        // Configure Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitGuest), for: .touchUpInside)
        
        // Configure Message Label
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // Arrange UI Elements
        let stackView = UIStackView(arrangedSubviews: [
            firstNameTextField,
            lastNameTextField,
            emailTextField,
            phoneTextField,
            addressTextField,
            submitButton,
            messageLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    // MARK: - Submit Action
    @objc private func submitGuest() {
       
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let address = addressTextField.text, !address.isEmpty else {
            messageLabel.text = "Please fill in all fields."
            messageLabel.textColor = .red
            return
        }
        
        messageLabel.text = ""
        
        let guests = Guest(id: 0,
                           firstName: firstName,
                           email: email,
                           lastName: lastName,
                           address: address,
                           phone: phone )
        // Call postGuests function
        Loading.shared.showLoading()
        GuestsViewModel.shared.post_put_Guests(param: guests,
                                               method: isUIType == .create ? .POST : .PUT,
                                               id: geustID)
        { response in
           
            DispatchQueue.main.async { [self] in
                if response.response.status == 201 {
                  
                    firstNameTextField.text = ""
                    lastNameTextField.text = ""
                    emailTextField.text = ""
                    phoneTextField.text = ""
                    addressTextField.text = ""
                    
                    messageLabel.text = response.response.message
                    messageLabel.textColor = .green

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){ [self] in
                        messageLabel.text = ""
                        Loading.shared.hideLoading()
                    }

                } else {
                    self.messageLabel.text = "Failed to create guest."
                    self.messageLabel.textColor = .red
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){ [self] in
                        messageLabel.text = ""
                        Loading.shared.hideLoading()
                    }
                }
            }
        }
    }
}

extension GeustController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        messageLabel.text = ""
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        messageLabel.text = ""
    }
    
    
}
