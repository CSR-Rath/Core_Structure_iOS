//
//  BecomeFirstResponderVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 20/3/25.
//

import UIKit




class BecomeFirstResponderVC: UIViewController, UITextFieldDelegate {
    
    var textField: UITextField!
    var isViewDidLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackgroundColor
        setupTextField()
        print("viewDidLoad")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                self.textField.becomeFirstResponder()
    }
    
    func setupTextField() {
        textField = UITextField(frame: CGRect(x: (screen.width-250)/2,
                                              y: (screen.height-50)/2,
                                              width: 250,
                                              height: 50))
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.text = ""
        textField.placeholder = "Enter your text."
        view.addSubview(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        self.view.endEditing(true) // Dismiss the keyboard when tapping outside the text field
    }
}



//import UIKit

class BottomSheetViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        let label = UILabel()
        label.text = "Hello from the Bottom Sheet!"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

