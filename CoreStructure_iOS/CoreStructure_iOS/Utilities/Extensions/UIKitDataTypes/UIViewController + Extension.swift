//
//  UIViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

enum IconButtonBar {
    case back
    case close
    case isEmpty
    
    var image: UIImage? {
        switch self {
        case .back:
            return  UIImage(named: "icBack")
        case .close:
            return .icAdd
        case .isEmpty:
            return UIImage()
        }
    }
}

//MARK: Handle Navigationbar
extension UIViewController{
    
    func leftBarButtonItem(iconButton: IconButtonBar = .back) {
        guard let icon = iconButton.image?.withRenderingMode(.alwaysOriginal) else {
            print("Icon bar invalid")
            return
        }
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: icon,
                style: .plain,
                target: self,
                action: iconButton != .isEmpty ? #selector(leftBarButtonItemAction) :  #selector(helperAction)
            )
        
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
        
        print("Action ==> back button")
    }
    
    

    
    func navigationBarAppearance(titleColor: UIColor = .black,
                                 barAppearanceColor: UIColor = .clear,
                                 barAppearanceScrollingColor: UIColor = .clear,
                                 shadowColorLine: UIColor = .clear) {
        
        let setupFont: UIFont = UIFont.appFont(style: .bold, size: 16)
        let largeFont: UIFont = UIFont.appFont(style: .bold, size: 34)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: setupFont
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: largeFont
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = barAppearanceColor
        appearance.shadowColor = shadowColorLine
        
        let appearanceScrolling = UINavigationBarAppearance()
        appearanceScrolling.configureWithOpaqueBackground()
        appearanceScrolling.backgroundColor = barAppearanceScrollingColor
        appearanceScrolling.shadowColor = shadowColorLine
        
        navigationController?.navigationBar.standardAppearance = appearanceScrolling
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    
}

// MARK: Action change screen view contoller
extension UIViewController{
    
    @objc func dismissVC(animated: Bool = true){
        self.dismiss(animated: animated)
    }
    
    @objc func popVC(animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    // pop to first step
    @objc func popToRootVC(animated: Bool = true){
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
