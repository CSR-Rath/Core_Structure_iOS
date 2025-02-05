//
//  CustomSegmentedView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/1/25.
//

import Foundation
import UIKit

enum DesignUISegmentedView{
    case home
    case setting
    case notification
}

class CustomSegmentedView: UIView {

    var buttons: [UIButton] = []
    private var selectorView: UIView!
    
    var selectedSegmentIndex: Int = 0{
        didSet{
            buttons.forEach({ btn in
                if selectedSegmentIndex == btn.tag {
                    btn.titleLabel?.fontBold(17)
                }else{
                    btn.titleLabel?.fontRegular(17)
                }
            })
        }
    }

    var segmentTitles: [String] = [] {
        didSet {
            setupSegments()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSelectorView() {
        selectorView = UIView()
        selectorView.backgroundColor = .white
        selectorView.layer.cornerRadius = 10
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectorView)
    }

    private func setupSegments() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index , title) in segmentTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.fontRegular(16)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            buttons.append(button)
            addSubview(button)
        }

        layoutButtons()
        updateSelectorView()
    }

    private func layoutButtons() {
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor),
                button.bottomAnchor.constraint(equalTo: bottomAnchor),
                button.leadingAnchor.constraint(equalTo: index == 0 ? leadingAnchor : buttons[index - 1].trailingAnchor),
                button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(buttons.count))
            ])
        }
        
        if let lastButton = buttons.last {
            lastButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }

    @objc private func segmentTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectedSegmentIndex = index
        updateSelectorView()
    }

    private func updateSelectorView() {
        guard !buttons.isEmpty else { return }
        
        let selectedButton = buttons[selectedSegmentIndex]
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame = selectedButton.frame
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectorView()
    }
}

class Controller: UIViewController {
    
    private let segmentedView = CustomSegmentedView()
    private let firstContentView = UIView()
    private let secondContentView = UIView()
    private let thirdContentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedView()
        setupContentViews()
    }

    private func setupSegmentedView() {
        segmentedView.segmentTitles = ["First", "Second"]
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.selectedSegmentIndex = 0

        view.addSubview(segmentedView)

        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupContentViews() {
        firstContentView.backgroundColor = .red
        secondContentView.backgroundColor = .green
        thirdContentView.backgroundColor = .blue
        
        firstContentView.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.translatesAutoresizingMaskIntoConstraints = false
        thirdContentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(firstContentView)
        view.addSubview(secondContentView)
        view.addSubview(thirdContentView)

        // Initial content view setup


        NSLayoutConstraint.activate([
            firstContentView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            firstContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            secondContentView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            secondContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            thirdContentView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            thirdContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thirdContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thirdContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // Hide all content views initially
        secondContentView.isHidden = true
        thirdContentView.isHidden = true
        
        // Add target for segmented view changes
        segmentedView.buttons.forEach { button in
            button.addTarget(self, action: #selector(segmentChanged), for: .touchUpInside)
        }
    }

    @objc  private func segmentChanged(at index: UIButton) {
        let index = index.tag
        firstContentView.isHidden = index != 0
        secondContentView.isHidden = index != 1
        thirdContentView.isHidden = index != 2
    }
}

