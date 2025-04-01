//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import UIKit

class BaseUIButton: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView!
    private let animationDuration: TimeInterval = 0.05
    private var nsContraint = NSLayoutConstraint()
    private var titleButton: String = ""
    
    var actionUIButton: (()->())?
    
    var isActionButton: Bool = true {
        didSet {
            setupButton()
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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17) // Consider dynamic type
        self.layer.cornerRadius = buttonHeight/2
        self.layer.borderWidth = 1
        self.setTitleColor(.white, for: .normal)
        
        nsContraint = heightAnchor.constraint(equalToConstant: buttonHeight)
        nsContraint.isActive = true
        
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
        
        self.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        self.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        animateButton(scale: 0.95, alpha: 0.5)
    }
    
    @objc private func buttonReleased() {
        print("buttonReleased")
        animateButton(scale: 1.0, alpha: 1)
    }
    
    @objc private func didTappedButton() {
        actionUIButton?()
       print("didTappedButton")
    }
    
    private func animateButton(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = alpha
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
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
        self.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        self.setTitleColor(.clear, for: .normal)
    }
    
    // Stop loading
    func stopLoading(){
        self.isUserInteractionEnabled = true
        self.activityIndicator.stopAnimating()
        self.setTitleColor(.white, for: .normal)
    }
    
    deinit {
        print("MainButton deinitialized")
        self.stopLoading()
    }
}


