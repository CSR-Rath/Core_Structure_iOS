//
//  SuccessfullyViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/7/25.
//

import UIKit

class SuccessfullyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var btnDone: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleButton = "Done"
        btn.actionUIButton = {
            self.popToVC(ofType: CustomTabBarVC.self, animated: true)
        }
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBarButtonItem(iconButton: .isEmpty)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.backgroundColor = .white
        title = "Susseccfully"
       
        setupConstraint()
    }
    
    
    
    private func setupConstraint() {
        
        view.addSubview(btnDone)
        
        NSLayoutConstraint.activate([
            
            btnDone.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .mainLeft),
            btnDone.rightAnchor.constraint(equalTo: view.rightAnchor, constant: .mainRight),
            btnDone.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .mainBottom),
        ])
    }
    
}
