//
//  SplashScreenVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/10/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    lazy var btnCustomTabBar: MainButton = {
        let btn = MainButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Custom", for: .normal)
        btn.addTargetButton(target: self, action: #selector(didTappedButton))
        btn.tag = 0
        return btn
    }()
    
    lazy var btnOriginal: MainButton = {
        let btn = MainButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Original", for: .normal)
        btn.addTargetButton(target: self, action: #selector(didTappedButton))
        btn.tag = 1
        return btn
    }()
    
    lazy var stackButton: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [btnCustomTabBar,btnOriginal])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle  = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
    }
}


extension SplashScreenVC{
    
    private func setupConstraint(){
        view.addSubview(stackButton)
        
        NSLayoutConstraint.activate([
            
            stackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            btnCustomTabBar.heightAnchor.constraint(equalToConstant: 50),
            btnOriginal.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    @objc private func didTappedButton(sender: UIButton){
         
        if sender.tag == 0 {
            let tabbar = CustomTabBarVC()
         
            self.navigationController?.pushViewController(tabbar, animated: true)
        }else{
            let tabbar = OriginalTabBarVC()
           
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
     }
    
}
