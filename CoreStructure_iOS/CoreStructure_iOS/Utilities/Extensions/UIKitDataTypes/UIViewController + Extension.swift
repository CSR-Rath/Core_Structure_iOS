//
//  UIViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

//MARK: Handle Navigationbar
extension UIViewController{
    
    func leftBarButtonItem(action: Selector? = #selector(leftBarButtonItemAction),
                           iconButton: UIImage? = UIImage(named: "icBackWhite"),
                           tintColor: UIColor! = .black
    ){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal).withTintColor(tintColor!),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    func rightBarButtonItem(action: Selector? = #selector(leftBarButtonItemAction),
                            iconButton: UIImage? =  UIImage(named: "icNextWhite")
    ){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    @objc private func leftBarButtonItemAction() {
        
        // Check if the current view controller is presented modally
        if (self.navigationController?.presentingViewController) != nil {
            print("dismiss"); self.dismiss(animated: true)
        } else {
            print("popViewController"); self.navigationController?.popViewController(animated: true)
        }
    }
    
    func navigationBarAppearance(titleColor: UIColor?,
                                 barColor: UIColor?){
        
        let setupFont: UIFont = UIFont.systemFont(ofSize: 16,weight: .bold)
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor ?? .white,
            .font: setupFont
        ]
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = barColor ?? .mainBlueColor
        appearance.shadowColor = barColor ?? .mainBlueColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: Action change screen view contoller
extension UIViewController{
    
    @objc func dismissViewController(animated: Bool = true){
        self.dismiss(animated: animated)
    }
    
    @objc func popViewController(animated: Bool = true){
        self.popViewController(animated: animated)
    }
    
    @objc func popToRootViewController(animated: Bool = true){
        navigationController?.popToRootViewController(animated: animated)
    }
    
    @objc func pushViewController(viewController: UIViewController){
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func popToViewController(viewController: UIViewController){
        navigationController?.popToViewController(viewController, animated: true)
    }

}


// MARK: EndEditing TextField When touch around else TextFields
extension UIViewController {

    @objc func dismissKeyboard() { //resingtextfield
        view.endEditing(true)
    }
}

extension UIViewController{
    
    @objc func shareView(viewToShare: UIView) {
        
        // Prepare the activity view controller with the view to share
        let activityViewController = UIActivityViewController(activityItems: [viewToShare],
                                                              applicationActivities: nil)
        
        // For iPads, you need to specify the source view for the popover
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewToShare
            popoverController.sourceRect = CGRect(x: viewToShare.bounds.midX,
                                                  y: viewToShare.bounds.midY,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Present the activity view controller to share
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func presentTransaction(){
        
        let vc = UIViewController()
        vc.transitioningDelegate = presentVC
        vc.modalPresentationStyle = .custom
        present(vc, animated: true) {
        }
    }
}







