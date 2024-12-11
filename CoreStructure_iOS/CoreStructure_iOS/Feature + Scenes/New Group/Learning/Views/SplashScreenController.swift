//
//  SplashScreenController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/11/24.
//

import UIKit

class SplashScreenController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Loading.shared.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0){
           
            let newVC = HomeController()
            pushNoback(newVC: newVC)
 

            Loading.shared.hideLoading()
        }
    }

}
