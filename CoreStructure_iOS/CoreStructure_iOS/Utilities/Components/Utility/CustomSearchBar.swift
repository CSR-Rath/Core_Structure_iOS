//
//  CustomSearchBar.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 13/2/25.
//

import Foundation
import UIKit

class CustomSearchBar: UITextField {
    
    private let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    private let cancelIcon = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func setupUI() {
        self.placeholder = "Search for everything here ..."
        self.borderStyle = .none
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.font = UIFont.systemFont(ofSize: 16)
        self.clearButtonMode = .never // We will manage clearing manually
        self.tintColor = .mainColor
        
        // Add left padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        self.leftView = leftPadding
        self.leftViewMode = .always
        
        // Search Icon
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        
        // Cancel Button (Initially hidden)
        cancelIcon.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelIcon.tintColor = .gray
        cancelIcon.isHidden = true
        cancelIcon.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        // Right View Container
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        searchIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        cancelIcon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        rightViewContainer.addSubview(searchIcon)
        rightViewContainer.addSubview(cancelIcon)
        
        self.rightView = rightViewContainer
        self.rightViewMode = .always
    }
    
    @objc private func textDidChange() {
        let hasText = !(self.text?.isEmpty ?? true)
        searchIcon.isHidden = hasText
        cancelIcon.isHidden = !hasText
    }
    
    @objc private func clearText() {
        self.text = ""
        textDidChange()
        self.resignFirstResponder() // Hide keyboard
    }
}
