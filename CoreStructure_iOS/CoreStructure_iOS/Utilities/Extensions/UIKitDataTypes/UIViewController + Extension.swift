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

    var image: UIImage? {
        switch self {
        case .back:
            return UIImage(named: "back_icon")
        case .close:
            return UIImage(named: "close_icon")
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
            action: #selector(leftBarButtonItemAction)
        )
    }

    
    func rightBarButtonItem(action: Selector? = #selector(leftBarButtonItemAction),
                            iconButton: IconButtonBar = .close){
        
        guard let icon = iconButton.image?.withRenderingMode(.alwaysOriginal) else {
            print("Icon bar invalid")
            return
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: icon,
            style: .plain,
            target: self,
            action: action
        )
    }
    
    @objc private func leftBarButtonItemAction() {
    
        if (self.navigationController?.presentingViewController) != nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        print("Action ==> back button")
    }
    
    func navigationBarAppearance(titleColor: UIColor,
                                 barColor: UIColor){
        
        let setupFont: UIFont = UIFont.systemFont(ofSize: 16,weight: .bold)
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: setupFont
        ]
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = barColor
        appearance.shadowColor = .red// barColor ?? .mainBlueColor // line appearenc bar

        // Apply to all navigation bars
//           UINavigationBar.appearance().standardAppearance = appearance
//           UINavigationBar.appearance().scrollEdgeAppearance = appearance // For scrollable views
//        
        navigationController?.navigationBar.standardAppearance = appearance
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
    
    @objc func popToRootVC(animated: Bool = true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    @objc func pushVC(to viewController: UIViewController, animated: Bool = true){
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @objc func popToVC(to viewController: UIViewController, animated: Bool = true){
        self.navigationController?.popToViewController(viewController, animated: animated)
    }

}


// MARK: EndEditing TextField When touch around else TextFields
extension UIView {

    @objc func dismissKeyboard() { //resingtextfield
        self.endEditing(true)
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
