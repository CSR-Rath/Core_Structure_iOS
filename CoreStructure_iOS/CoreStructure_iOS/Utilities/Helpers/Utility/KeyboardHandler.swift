//
//  KeyboardHandler.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import UIKit

let keyboardHandler = KeyboardHandler()

class KeyboardHandler {
    
    var onKeyboardWillShow: ((_ keyboardHeight: CGFloat) -> Void)?
    var onKeyboardWillHide: (() -> Void)?
    
    init() {
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height + 10  // Adding extra padding
            self.onKeyboardWillShow?(-keyboardHeight);  print("Keyboard height: \(keyboardHeight)")
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        onKeyboardWillHide?();   print("Keyboard will hide")
    }
}
