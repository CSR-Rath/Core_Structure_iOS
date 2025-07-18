//
//  ActionUIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit

extension UIView{
    
    private func viewContainingController() -> UIViewController? {
        // for use push view controller in the UIView
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    @objc func dismissVC(animated: Bool = true){
        viewContainingController()?.navigationController?.dismiss(animated: animated)
    }
    
    @objc func popVC(animated: Bool = true){
        viewContainingController()?.navigationController?.popViewController(animated: animated)
    }
    
    @objc func popToRootVC(animated: Bool = true){
        viewContainingController()?.navigationController?.popToRootViewController(animated: animated)
    }
    
    @objc func pushVC(to viewController: UIViewController, animated: Bool = true){
        viewContainingController()?.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @objc func popToVC(to viewController: UIViewController, animated: Bool = true){
        viewContainingController()?.navigationController?.popToViewController(viewController, animated: animated)
    }
    
    func presentVC(to viewController: UIViewController, animated: Bool = true){
        viewContainingController()?.present(viewController, animated: animated)
    }
    
    
    func shareViewScreenshot(title: String = "") {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
        // Include the title and image as items to share
        let items: [Any] = [title, image] // Add title and image to the share sheet
        
        guard let viewController = viewContainingController() else {
            print("Error: No view controller found")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // iPad-specific handling
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = self.bounds
            popoverController.permittedArrowDirections = [.up, .down]
        }
        
        viewController.present(activityViewController, animated: true)
    }
    
    func isGestureViewAction(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        print("View was tapped!")
    }
}
