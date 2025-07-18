//
//  UITextField + Extension.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 11/10/24.
//

import UIKit

extension UITextField {
    
    func isPadding(left: CGFloat, right: CGFloat) {
        // Set padding for left side
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        // Set padding for right side
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    
    func isPlaceholder(text: String, font: UIFont?, color: UIColor = .lightGray) {
        
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
                .font: font ?? UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
    }
}
