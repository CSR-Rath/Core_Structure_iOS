//
//  PanGestureVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import UIKit

class PanGestureVC: UIViewController {
    
    lazy var backGrountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupConstraint()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupConstraint(){
        view.addSubview(backGrountView)
        view.addSubview(containerView)
        
        backGrountView.addTapGesture(target: self, action: #selector(didTappedDismiss))
        
        
        view.addPanGesture()
        //        UIView.didTapGesture = {
        //            print("didTapGesture")
        //            self.dismiss(animated: true)
        //        }
        
        NSLayoutConstraint.activate([
            
            backGrountView.topAnchor.constraint(equalTo: view.topAnchor),
            backGrountView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backGrountView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backGrountView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 400),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    @objc func didTappedDismiss(){
        
        //        UIView.animate(withDuration: 0.1) {
        //            self.containerView.transform = .identity
        //        }
        
        self.dismiss(animated: true)
        
    }
}



extension PanGestureVC {
    
    
    
    
}
