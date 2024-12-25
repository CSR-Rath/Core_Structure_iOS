//
//  PanGestureVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/10/24.
//

import UIKit

class PanGestureVC: UIViewController {
    
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
        view.addSubview(containerView)

        HandleTapPanGesture.shared.addTapGesture(to: view)
        HandleTapPanGesture.shared.addPanGesture(to: view)
        HandleTapPanGesture.shared.onTap = {
            self.didTappedDismiss()
        }

        containerView.tapGestureRecognizer()
        
        
        NSLayoutConstraint.activate([
            
            containerView.heightAnchor.constraint(equalToConstant: 400),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    @objc func didTappedDismiss(){
        self.dismiss(animated: true)
        
    }
}







