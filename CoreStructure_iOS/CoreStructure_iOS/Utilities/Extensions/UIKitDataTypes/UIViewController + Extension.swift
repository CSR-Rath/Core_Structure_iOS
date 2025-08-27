//
//  UIViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

extension UIViewController{
    
    func leftBarButtonItem(icon: UIImage? = UIImage(named: "icBack")?.withRenderingMode(.alwaysOriginal),
                           isSwiping: Bool? = true,
                           action: Selector? = nil
                           
    ) {
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: icon,
            style: .plain,
            target: self,
            action: icon == nil ?  #selector(helperAction) : action == nil ?  #selector(leftBarButtonItemAction) :  action
        )
        
        if isSwiping == false  {
            isSwipingBack = false
        }else{
            isSwipingBack = true
        }
        
    }
    
    @objc private func helperAction() {
        print("==> helperAction")
    }
    
    @objc private func leftBarButtonItemAction() {
        
        if (self.navigationController?.presentingViewController) != nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: Action change screen view contoller
extension UIViewController{

    @objc func popTopTabBarAndReload(){
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if vc is CustomTabBarVC {
                    nav.popToViewController(vc, animated: true)
                    NotificationCenter.default.post(name: .refreshTabBar, object: nil)
                    break
                }
            }
        }
    }
    
    @objc func popTopTabBar(){
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if vc is CustomTabBarVC {
                    nav.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    

    
    @objc func dismissVC(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }

    
    @objc func popVC(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    // pop to first step
    @objc func popToRootVC(animated: Bool = true){
        
        guard let window = UIApplication.shared.windows.first,
              let navController = self.navigationController else { return }
        
        // import animation when
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            navController.popToRootViewController(animated: animated)
        })
    }
    
    
    @objc func popToRootWhenPresentVC(animated: Bool = true){
        
        guard let window = UIApplication.shared.windows.first,
              let navController = self.navigationController else { return }
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            navController.popToRootViewController(animated: animated)
        })
        
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    
    @objc func pushVC(to viewController: UIViewController, animated: Bool = true){
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // pop to controller
    func popToVC<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        
        for vc in viewControllers {
            if vc is T {
                self.navigationController?.popToViewController(vc, animated: animated)
                break
            }
        }
    }
}

// MARK: EndEditing TextField When touch around else TextFields
extension UIView {
    @objc func dismissKeyboard() { //resingtextfield
        endEditing(true)
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

