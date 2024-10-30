//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import Foundation
import UIKit


class YellowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(){
        
        self.setTitle("title", for: .normal)
        self.backgroundColor = .mainColor
        self.layer.cornerRadius = 10
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
