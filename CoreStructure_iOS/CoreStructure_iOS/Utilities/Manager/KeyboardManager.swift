//
//  KeyboardHandler.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import UIKit

let keyboardManager = KeyboardManager()

class KeyboardManager {

    var onKeyboardWillShow: ((_ keyboardHeight: CGFloat) -> Void)?
    var onKeyboardWillHide: (() -> Void)?
    
    init() {
        print("KeyboardManager init")
        setupKeyboardObservers()
    }
    
    deinit {
        print("Deinit KeyboardManager.")
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
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.onKeyboardWillShow?(-keyboardHeight)
            print("Keyboard height: \(keyboardHeight)")
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.onKeyboardWillHide?()
        print("Keyboard will hide")
    }
}


