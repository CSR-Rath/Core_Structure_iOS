//
//  UITextField + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/10/24.
//

import UIKit

extension UITextField {
    func addToolbar(cancelAction: Selector? = #selector(cancelTapped),
                    doneAction: Selector? = #selector(doneTapped)) {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create Cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelAction)
        
        // Create Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: doneAction)
        
        // Add flexible space to push buttons to the right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Add buttons to the toolbar
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        // Assign the toolbar to the text field's inputAccessoryView
        self.inputAccessoryView = toolbar
    }
    
    @objc private func cancelTapped() {
        self.text = ""
        self.resignFirstResponder() // Dismiss keyboard
    }

    @objc private func doneTapped() {
        self.resignFirstResponder() // Dismiss keyboard
        // Add any additional action for done button if needed
    }
    
}


import UIKit

class DemoTextFieldAddTabBar: UIViewController {

    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTextField()
    }

    private func setupTextField() {
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        textField.addToolbar()
        // Add toolbar to the text field
//        textField.addToolbar(cancelAction: #selector(cancelTapped), doneAction: #selector(doneTapped))
    }

    @objc private func cancelTapped() {
        textField.resignFirstResponder() // Dismiss keyboard
    }

    @objc private func doneTapped() {
        textField.resignFirstResponder() // Dismiss keyboard
        // Add any additional action for done button if needed
    }
}
