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
    
    @objc func touchDismiss(){
        self.dismiss(animated: true) {
        }
    }
    
    @objc func touchPopViewController(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    @objc func touchPopToRootViewController(animated: Bool = true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    
    
    @objc func touchPopToViewController(){
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
                       iconButton: UIImage? = UIImage(named: "icBackWhite"),
                       tintColor: UIColor = .white
    ){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal).withTintColor(tintColor),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    func rightBarButton(action: Selector? = #selector(popVC),
                        iconButton: UIImage? = UIImage(named: "icNextWhite")
    ){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: iconButton?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    

   @objc private func popVC(){
       print("popVC ===> buttonBack")
        self.navigationController?.popViewController(animated: true)
    }
  
    
}


//MARK: Handle NavigationViewController
extension UIViewController{
    
    func setupTitleNavigationBar( font: UIFont? = UIFont.systemFont(ofSize: 17,
                                                                    weight: .regular),
                                  titleColor: UIColor = .white , backColor: UIColor = .mainBlueColor){
        

        // setup title font color
            let titleAttribute = [
                NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: titleColor,
            ]

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backColor
            appearance.shadowColor = backColor
            appearance.titleTextAttributes = titleAttribute as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
