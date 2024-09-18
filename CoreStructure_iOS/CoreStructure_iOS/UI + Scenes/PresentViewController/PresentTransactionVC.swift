//
//  PresentTransactionVC.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import UIKit

class PresentTransactionVC: UIViewController {
    
    lazy var containView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .orange
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrains()
        
    }
    
    private func setupConstrains(){
        
        view.addSubview(containView)
        
        NSLayoutConstraint.activate([
            containView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}
