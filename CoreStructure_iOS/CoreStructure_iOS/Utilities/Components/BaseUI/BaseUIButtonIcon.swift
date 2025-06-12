//
//  BaseUIButtonIcon.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 14/2/25.
//

import Foundation
import UIKit

class BaseUIButtonIcon: BaseUIButtonAnimation{
    
    var actionButton: (()->())?
    
    func setupButton(isLeftIcon: Bool?, spacing: CGFloat?, iconHeight: CGFloat?){
        
        if let status = isLeftIcon{
            handlerStack(isLeftIcon: status)
        }
        
        if let spac = spacing{
            stackContainer.spacing = spac
        }
        
        if let height = iconHeight{
            iconHeightConstraint.constant = height
            layoutIfNeeded()
        }
    }
    
    
    private var iconHeightConstraint = NSLayoutConstraint()
    
    lazy var imgIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "_"
        lbl.fontBold(14)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var stackContainer : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.isUserInteractionEnabled = false
        stack.spacing = 5
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.backgroundColor = .mainColor
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped(){
        actionButton?()
    }
    
    
    func uiEdgeInsets(top: CGFloat = 0,
                      left: CGFloat = 0,
                      bottom: CGFloat = 0,
                      right: CGFloat = 0
    ){
    
        stackContainer.layoutMargins = UIEdgeInsets(top: top,
                                                    left: left,
                                                    bottom: bottom,
                                                    right: right)
        stackContainer.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupUI(){
        handlerStack()
        addSubview(stackContainer)
        
        iconHeightConstraint = imgIcon.widthAnchor.constraint(equalToConstant: 20)
        iconHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            stackContainer.leftAnchor.constraint(equalTo: leftAnchor),
            stackContainer.rightAnchor.constraint(equalTo: rightAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackContainer.topAnchor.constraint(equalTo: topAnchor),
            
        ])
    }
    
    
    private func handlerStack(isLeftIcon: Bool = false){
        stackContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if isLeftIcon{
            stackContainer.addArrangedSubview(imgIcon)
            stackContainer.addArrangedSubview(lblTitle)
        }else{
            stackContainer.addArrangedSubview(lblTitle)
            stackContainer.addArrangedSubview(imgIcon)
        }
    }
}


class BaseUIButtonAnimation: UIButton {
    
    private let animationDuration: TimeInterval = 0.05
    
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
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        print("Button Pressed") // Print response when button is pressed
        animateButton(scale: 0.95, alpha: 0.5)
    }
    
    @objc private func buttonReleased() {
        print("Button Released") // Print response when button is released
        animateButton(scale: 1.0, alpha: 1)
    }
    
    private func animateButton(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = alpha
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
    }
    
    deinit {
        print("MainButton deinitialized")
    }
}
