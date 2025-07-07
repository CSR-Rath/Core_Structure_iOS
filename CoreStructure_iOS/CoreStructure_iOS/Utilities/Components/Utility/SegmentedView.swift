//
//  SegmentedView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import UIKit

class SegmentedView: UIView {
    private var isFirstTime = false
    
    var didSectedBuuton: ((_ index: Int)->())?
    
    var selectedIndex: Int = 0{
        didSet{
            for (index, item) in buttons.enumerated(){
                if selectedIndex == index{
                    item.setTitleColor(.white, for: .normal)
                    item.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                    updateLocationAnimation(button: item)
                }else{
                    item.setTitleColor(.black, for: .normal)
                    item.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                }
            }
        }
    }
    
    
    var items: [String] = [] {
        didSet {
            setupButtons()
        }
    }

    // MARK: - Private Properties
    
    private var buttons: [UIButton] = []
    private var backgroundIndicatorView: UILabel?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupAnimateLabelView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimateLabelView()
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = frame.width / CGFloat(buttons.count)
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(
                x: CGFloat(index) * buttonWidth,
                y: 0,
                width: buttonWidth,
                height: frame.height
            )
        }
        
        // Set the frame for the backgroundIndicatorView initially
//        updateLocationAnimation(button: buttons[selectedIndex],isFirstTime: false)

    }
}

extension SegmentedView{
    
    private func updateLocationAnimation(button: UIButton, isFirstTime: Bool = true){

        let duration = isFirstTime ? 0.3 : 0.0

        UIView.animate(withDuration: duration) { [self] in
            backgroundIndicatorView?.frame = CGRect(
                x: button.frame.minX,
                y: 0,
                width: button.frame.width,
                height: button.frame.height
            )
        }
    }

    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return } // find
        
        selectedIndex = index
        didSectedBuuton?(index)
    }
    
    private func setupAnimateLabelView() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        // Create the background indicator view
        backgroundIndicatorView = UILabel()
        backgroundIndicatorView?.text = ""
        backgroundIndicatorView?.textAlignment = .center
        backgroundIndicatorView?.backgroundColor = .orange
        backgroundIndicatorView?.textColor = .white
        backgroundIndicatorView?.layer.cornerRadius = 22
        backgroundIndicatorView?.font = .systemFont(ofSize: 16, weight: .bold)
        backgroundIndicatorView?.clipsToBounds = true
        if let indicator = backgroundIndicatorView {
            addSubview(indicator)
        }
    }
    
    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        items.forEach({ item in
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            addSubview(button)
            buttons.append(button)
        })
    }
}







