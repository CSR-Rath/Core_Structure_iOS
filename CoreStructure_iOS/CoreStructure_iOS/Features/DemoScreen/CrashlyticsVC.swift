//
//  CrashlyticsViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 25/6/25.
//

import UIKit

class CrashlyticsVC: BaseUIViewConroller {
    
    var a: Int! = nil
    var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crashlytic"
        view.backgroundColor = .white
        
        let buttonA = BaseUIButton()
        buttonA.setTitle("Crash App A", for: .normal)
        buttonA.addTarget(self, action: #selector(tappedA), for: .touchUpInside)
        
        
        let buttonB = BaseUIButton()
        buttonB.setTitle("Crash App B", for: .normal)
        buttonB.addTarget(self, action: #selector(tappedB), for: .touchUpInside)
        
        
        let buttonC = BaseUIButton()
        buttonC.setTitle("Crash App C", for: .normal)
        buttonC.addTarget(self, action: #selector(tappedC), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [
            buttonA,
            buttonB,
            buttonC,
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func tappedA(){
        print("Action Button: \(a!)")
    }
    
    @objc private func tappedB(){
        print("Action Button: \(a!)")
    }
    
    @objc private func tappedC(){
        print("Action Button: \(a!)")
    }
    
}
