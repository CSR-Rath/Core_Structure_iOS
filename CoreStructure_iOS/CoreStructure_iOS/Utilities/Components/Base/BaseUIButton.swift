//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import Foundation
import UIKit


class BaseUIButton: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView!
    private let animationDuration: TimeInterval = 0.05
    private var nsContraint = NSLayoutConstraint()
    
    var isActionButton: Bool = true {
        didSet {
            setupButton()
        }
    }
    
    var titleButton: String = "" {
        didSet {
            setTitle(titleButton, for: .normal)
        }
    }
    
    var buttonHeight: CGFloat = 50{
        didSet{
            layer.cornerRadius = buttonHeight/2
            nsContraint.constant = buttonHeight
            layoutIfNeeded()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        titleLabel?.font = UIFont.systemFont(ofSize: 17) // Consider dynamic type
        layer.cornerRadius = buttonHeight/2
        layer.borderWidth = 1
        
        nsContraint = heightAnchor.constraint(equalToConstant: buttonHeight)
        nsContraint.isActive = true
        
        if isActionButton {
            isUserInteractionEnabled = true
            layer.borderColor = UIColor.clear.cgColor
            backgroundColor = .mainBlueColor
            alpha = 1
        } else {
            isUserInteractionEnabled = false
            layer.borderColor = UIColor.white.cgColor
            alpha = 0.5
        }
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        animateButton(scale: 0.95, alpha: 0.5)
    }
    
    @objc private func buttonReleased() {
        animateButton(scale: 1.0, alpha: 1)
    }
    
    private func animateButton(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = alpha
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
//            self.isUserInteractionEnabled = scale == 1.0
        }
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Start loading
    func startLoading() {
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        setTitle("", for: .normal) // Optionally hide the title
    }
    
    // Stop loading
    func stopLoading() {
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        setTitle(titleButton, for: .normal) // Restore the title
        
        
        
    }
    
    deinit {
        stopLoading()
        print("MainButton deinitialized")
    }
}


