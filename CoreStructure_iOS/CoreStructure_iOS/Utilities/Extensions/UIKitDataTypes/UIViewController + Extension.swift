//
//  UIViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit


//MARK: For action
extension UIViewController{
    
    
    @objc private func ImageSharing(viewSharing: UIView) {
        
        // Prepare the activity view controller
        let activityViewController = UIActivityViewController(activityItems: [viewSharing],
                                                              applicationActivities: nil)
        
        // For iPads, you must specify the source view
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewSharing
            popoverController.sourceRect = CGRect(x: viewSharing.bounds.midX,
                                                  y: viewSharing.bounds.midY,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
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
        vc.transitioningDelegate = presentVC
        vc.modalPresentationStyle = .custom
        present(vc, animated: true) {
        }
    }
}


//MARK: Handle NavigationBar
extension UIViewController{
    
    func leftBarButton(action: Selector? = #selector(popVC),
                       iconButton: UIImage? = UIImage(named: "icBack")
    ){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    func rightBarButton(action: Selector? = #selector(popVC),
                        iconButton: UIImage? = UIImage(named: "icNext")
    ){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    func setupFontNavigationBar(){
        
    }
    
    
    
   @objc private func popVC(){
       print("popVC ===> buttonBack")
        self.navigationController?.popViewController(animated: true)
    }
    
}

