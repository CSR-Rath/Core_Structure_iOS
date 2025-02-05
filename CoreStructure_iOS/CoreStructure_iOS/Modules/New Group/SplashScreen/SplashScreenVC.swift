//
//  SplashScreenVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/10/24.
//

import UIKit

class SplashScreenVC: BaseInteractionController {
    
    lazy var btnCustomTabBar: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleButton = "Custom"
        btn.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    lazy var btnOriginal: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Original", for: .normal)
        btn.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var stackButton: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [btnCustomTabBar, btnOriginal])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
    }
    
    private func setupConstraint() {
        view.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            stackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }
    
    @objc private func didTappedButton(sender: UIButton) {
        
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        
        SceneDelegate.shared.gotoTabBar()
        
        if sender.tag == 0 {
//            btnCustomTabBar.startLoading()
//            self.navigationController?.pushViewController(vc, animated: true)
        }else{
//            Loading.shared.showLoading()
//            btnCustomTabBar.stopLoading()
        }
    }
}

class TestVC: BaseInteractionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
