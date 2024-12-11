//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import Foundation
import UIKit


class MainButton: UIButton {
    
    
    
    var isActionButton: Bool = true {
        didSet {
            setupButton()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
    
        self.titleLabel?.fontMedium(17)
        
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if isActionButton {
            self.isUserInteractionEnabled = true
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = .mainBlueColor
            self.alpha = 1
        } else {
            self.isUserInteractionEnabled = false
            self.layer.borderColor = UIColor.white.cgColor
            self.alpha = 0.5
        }
        
        // Add target for touch down event
        self.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        // Animate scale down when pressed
        UIView.animate(withDuration: 0.05) {
            self.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.90)
        }
    }
    
    @objc private func buttonReleased() {
        // Animate scale back to original size
        UIView.animate(withDuration: 0.05, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    

}


class MainButtonOnSetHeigth: UIButton {
    
    var isActionButton: Bool = true {
        didSet {
            setupButton()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
    
        self.titleLabel?.fontMedium(17)
        
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        
        if isActionButton {
            self.isUserInteractionEnabled = true
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = .mainBlueColor
            self.alpha = 1
        } else {
            self.isUserInteractionEnabled = false
            self.layer.borderColor = UIColor.white.cgColor
            self.alpha = 0.5
        }
        
        // Add target for touch down event
        self.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        // Animate scale down when pressed
        UIView.animate(withDuration: 0.05) {
            self.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.90)
        }
    }
    
    @objc private func buttonReleased() {
        // Animate scale back to original size
        UIView.animate(withDuration: 0.05, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    

}
