//
//  SegmentedView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/11/24.
//

import UIKit

//
//
//class SegmentedView: UIView {
//
//    // MARK: - Properties
//
//    var selectedIndex: Int = 0 {
//        didSet {
//            updateSelectedIndex()
//        }
//    }
//
//    var items: [String] = [] {
//        didSet {
//            setupButtons()
//        }
//    }
//
//    var itemFont: UIFont = .systemFont(ofSize: 16, weight: .medium) {
//        didSet {
//            setupButtons()
//        }
//    }
//
//    var itemColor: UIColor = .systemGray {
//        didSet {
//            setupButtons()
//        }
//    }
//
//    var selectedItemColor: UIColor = .black {
//        didSet {
//            setupButtons()
//        }
//    }
//
//    var backgroundColors: UIColor = .systemBackground {
//        didSet {
//            setupView()
//        }
//    }
//
//    var cornerRadius: CGFloat = 8 {
//        didSet {
//            setupView()
//        }
//    }
//
//    // MARK: - Private Properties
//
//    private var buttons: [UIButton] = []
//    private var bottomIndicatorView: UIView?
//
//    // MARK: - Initialization
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    // MARK: - Private Methods
//
//    private func setupView() {
//        self.backgroundColor = backgroundColor
//        self.layer.cornerRadius = cornerRadius
//        self.clipsToBounds = true
//    }
//
//    private func setupButtons() {
//        buttons.forEach { $0.removeFromSuperview() }
//        buttons.removeAll()
//
//        for item in items {
//            let button = UIButton()
//            button.setTitle(item, for: .normal)
//            button.titleLabel?.font = itemFont
//            button.setTitleColor(itemColor, for: .normal)
//            button.setTitleColor(selectedItemColor, for: .selected)
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//            button.backgroundColor =  .clear
//            addSubview(button)
//            buttons.append(button)
//        }
//
//        updateSelectedIndex()
//    }
//
//    private func updateSelectedIndex() {
//        for (index, button) in buttons.enumerated() {
//            button.isSelected = index == selectedIndex
//        }
//
//        if bottomIndicatorView == nil {
//            let indicatorView = UIView()
//            indicatorView.backgroundColor = .red
//            addSubview(indicatorView)
//            bottomIndicatorView = indicatorView
//        }
//
//        let selectedButton = buttons[selectedIndex]
//
//        // Animate the indicator to the selected button's position
//        UIView.animate(withDuration: 0.3) {
//            self.bottomIndicatorView?.frame = CGRect(
//                x: selectedButton.frame.minX,
//                y: 0,
//                width: selectedButton.frame.width,
//                height: selectedButton.frame.height
//            )
//        }
//
//
//
////        // Animate the indicator to the selected button's position
////        UIView.animate(withDuration: 0.3) {
////            self.bottomIndicatorView?.frame = CGRect(
////                x: selectedButton.frame.minX,
////                y: self.frame.height - 4,
////                width: selectedButton.frame.width,
////                height: 4
////            )
////        }
//    }
//
//    @objc private func buttonTapped(_ sender: UIButton) {
//        guard let index = buttons.firstIndex(of: sender) else { return }
//        selectedIndex = index
//    }
//
//    // MARK: - Layout
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let buttonWidth = frame.width / CGFloat(buttons.count)
//        for (index, button) in buttons.enumerated() {
//
//            button.frame = CGRect(
//                x: CGFloat(index) * buttonWidth,
//                y: 0,
//                width: buttonWidth,
//                height: frame.height
//            )
//        }
//    }
//}
//
//
//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        let segmentedView = SegmentedView(frame: CGRect(x: 16,
//                                                        y: 100,
//                                                        width: view.bounds.width - 32,
//                                                        height: 44))
//        segmentedView.items = ["Option 1", "Option 2", "Option 3"]
//        segmentedView.selectedIndex = 0
//        segmentedView.itemFont = .systemFont(ofSize: 16, weight: .medium)
//        segmentedView.itemColor = .orange
//        segmentedView.selectedItemColor = .red
//        segmentedView.backgroundColor = .clear
//        segmentedView.cornerRadius = 8
////        segmentedView.backgroundColors = .green
//
//        view.addSubview(segmentedView)
//    }
//
//}


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
        updateLocationAnimation(button: buttons[selectedIndex],isFirstTime: false)

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


