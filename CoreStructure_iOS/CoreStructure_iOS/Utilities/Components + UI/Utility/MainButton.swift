//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import Foundation
import UIKit


class MainButton: UIButton {
    
    
    var isActionButton: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(){
        
        self.setTitle("Button", for: .normal)
      
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if isActionButton {

            self.isUserInteractionEnabled = true
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = .mainColor
        }else{

            self.isUserInteractionEnabled = false
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .mainColor.withAlphaComponent(0.5)
        }
    }
}
