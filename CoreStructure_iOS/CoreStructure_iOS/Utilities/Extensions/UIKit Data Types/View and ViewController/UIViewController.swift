//
//  UIViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit


//MARK: For action
extension UIViewController{
    
    @objc func dismiss(_ Complete: Complete ){
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func popViewController(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func popToViewController(){
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    @objc func presentTransaction(){
        
        let vc = UIViewController()
        vc.transitioningDelegate = presentationStyle
        vc.modalPresentationStyle = .custom
        present(vc, animated: true) {
           //
        }
    }
    
    

}



//MARK: For variable
extension UIViewController{

    static var size = 12
    static var totalSize = 0
    static var currentPage = 0
    
    
    
}

