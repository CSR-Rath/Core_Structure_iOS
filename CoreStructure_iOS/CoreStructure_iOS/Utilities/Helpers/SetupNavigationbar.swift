//
//  SetupNavigationbar.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import UIKit


class SetupNavigationbar : UIViewController, UIGestureRecognizerDelegate {
    
    var didTappedRightButton:(()->())?
    
    func setupNavigationBar( isEnabled: Bool = true,
                             isBack: Bool = true,
                             title: String = "",
                             action: Selector = #selector(goBack)){
        
        // Customize the navigation bar appearance
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        self.navigationController?.title = title
        
        // Add a back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        
        // Add a right button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(tappedRight)
        )
        
        //Enable swapped navigation
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    
    @objc  func goBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedRight() {
        didTappedRightButton?()
    }
}
