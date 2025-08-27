//
//  MainButton.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import UIKit


//MARK: - Noted

//button.actionUIButton = { [weak self] in
//    self?.doSomething()
//}

//button.actionUIButton = {
//    self.doSomething()  // 'self' is the view controller strongly captured here
//}

//@MainActor
class BaseUIButton: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView!
    private let animationDuration: TimeInterval = 0.05
    private var nsContraint = NSLayoutConstraint()

    var onTouchUpInside: (()->())?
    
    var titleButton: String = ""{
        didSet{
            self.setTitle(titleButton, for: .normal)
        }
    }
    
    var isActionButton: Bool = true {
        didSet {
            setupButton()
        }
    }
    
    var buttonHeight: CGFloat = 50{
        didSet{
            layer.cornerRadius = buttonHeight/2
            nsContraint.isActive = false
            nsContraint.constant = buttonHeight
            nsContraint.isActive = true
//            self.if
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupActivityIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoading), name: .stopButtonLoading, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        self.titleLabel?.fontMedium(17, color: .white)
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
        }
        else {
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
        animateButton(scale: 1.0, alpha: 1)
    }
    
    @objc private func didTappedButton() {
        onTouchUpInside?()
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
    
    func startLoading() {
        guard activityIndicator != nil else { return }
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
            self.setTitleColor(.clear, for: .normal)
        }
    }
    

    @objc func stopLoading(){
        guard activityIndicator != nil else { return }
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            self.setTitleColor(.white, for: .normal)
        }
    }
    
    deinit {
        let title = self.currentTitle ?? "No Title"
        print("✅ BaseUIButton is deinitialized \(title)")
        NotificationCenter.default.removeObserver(self)
    }
}



extension Notification.Name {
    static let stopButtonLoading = Notification.Name("stopButtonLoading")
}
