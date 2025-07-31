//
//  SuccessfullyViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 3/7/25.
//

import UIKit

class SuccessfullyVC: UIViewController {
    
    lazy var imageSucces: UIImageView = {
        let img = UIImageView()
        img.image = .imgSuccess
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var btnDone: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleButton = "Done"
        btn.actionUIButton = { [weak self] in
            self?.popToRootVC(animated: false)
        }
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBarButtonItem(icon: nil)
        view.backgroundColor = .red
        title = "Susseccfully"
        setupConstraint()
    }
    
    private func setupConstraint() {
        
        view.addSubviews(of:imageSucces, btnDone)
        
        NSLayoutConstraint.activate([
            
            imageSucces.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSucces.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 100),
            imageSucces.widthAnchor.constraint(equalToConstant: 200),
            
            btnDone.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .mainLeft),
            btnDone.rightAnchor.constraint(equalTo: view.rightAnchor, constant: .mainRight),
            btnDone.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .mainBottom),
        ])
    }
}
