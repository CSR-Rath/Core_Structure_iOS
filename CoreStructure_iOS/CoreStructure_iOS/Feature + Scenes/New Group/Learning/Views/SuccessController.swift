//
//  SuccessController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/11/24.
//

import UIKit

class SuccessController: UIViewController {
    let btnDone = MainButton()
    
    let imgLogo = UIImageView()
    let lblTitle = UILabel()
    let lblDescription = UILabel()
    
    lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imgLogo,lblTitle,lblDescription])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleNavigationBar(backColor: .white)
        // Disable swipe pop
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setupTitleNavigationBar(titleColor: .white, backColor: .mainBlueColor)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        leftBarButton(action: #selector(touchPopToRootViewController),
                      iconButton: .icCloseMain,
                      tintColor: .mainBlueColor)
        setupUI()
        
    }
    
    
    
    private func setupUI(){
        
        view.addSubview(stack)
        imgLogo.image = .imgSuccess
        
        lblTitle.text = "Payment Success!"
        lblTitle.fontBold(24)
        
        
        lblDescription.text = "Thank you for your order"
        lblDescription.fontRegular(18)
        
        
        btnDone.setTitle("Done", for: .normal)
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        btnDone.addTargetButton(target: self, action: #selector(touchPopToRootViewController))
        view.addSubview(btnDone)
        
        NSLayoutConstraint.activate([
        
            stack.leftAnchor.constraint(equalTo: view.leftAnchor),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            
            imgLogo.heightAnchor.constraint(equalToConstant: 200),
            imgLogo.widthAnchor.constraint(equalToConstant:  200),
            
        
            btnDone.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            btnDone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnDone.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
        
        
    }

}

func pushNoback(newVC: UIViewController) {
    let navigationController = UINavigationController(rootViewController: newVC)
    UIApplication.shared.windows.first?.rootViewController = navigationController
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}
