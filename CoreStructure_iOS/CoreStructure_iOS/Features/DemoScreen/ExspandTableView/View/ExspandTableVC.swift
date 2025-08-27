//
//  ViewController.swift
//  ExspandTable
//
//  Created by Rath! on 8/5/24.
//

import UIKit

class ExspandTableVC: BaseUIViewConroller {
    
    lazy var btnSingleExspand: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setTitle("Single Exspand", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(tappedBtnSingle), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnMuntipleExspand: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setTitle("Muntiple Exspand", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(tappedBtnMuntiple), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackButton: UIStackView = {
        let statk = UIStackView(arrangedSubviews: [btnSingleExspand,btnMuntipleExspand])
        statk.axis = .vertical
        statk.spacing = 20
        statk.distribution = .fillEqually
        statk.alignment = .fill
        statk.translatesAutoresizingMaskIntoConstraints = false
        return statk
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Exspand Table"
        setupConstrain()
    }

    @objc private func tappedBtnMuntiple(){
        let vc = ExpandedMultipleSectionVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func tappedBtnSingle(){
        let vc = ExspandSingleSectionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupConstrain(){
        view.addSubview(stackButton)
        NSLayoutConstraint.activate([
            stackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnSingleExspand.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

