//
//  CreateUIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit


extension UIView {

    @objc private func didDoneButton() {
        self.endEditing(true) //dismiss keyboard
    }
    
    func createTooBar(title: String = "Done", target: Any? = nil, action: Selector? = #selector(didDoneButton)) -> UIView {
        //MARK: - How to use if. textField.inputAccessoryView = view.addTooBar()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        let doneButton = UIBarButtonItem(title: title,
                                         style: .plain,
                                         target: target ?? self,
                                         action: action)
        
        toolbar.items = [flexibleSpace, doneButton]
        
        return toolbar
    }

    
    func createBarAppearanceView(color: UIColor){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: barAppearanHeight))
        view.backgroundColor = color
        self.addSubview(view)
    }
    
}
