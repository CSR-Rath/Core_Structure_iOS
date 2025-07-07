//
//  Present.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 27/8/24.
//

import Foundation
import UIKit


func usingPresentationController( controller: UIViewController) {
    
    //MARK: Call it
    let vc =  UIViewController()
    vc.transitioningDelegate = presentVC
    vc.modalPresentationStyle = .custom
    controller.present(vc, animated: true) {
        
    }
}

let presentVC = PresentationStyleManager()

class PresentationController: UIPresentationController {
    
    private var dimmingView: UIView?
   
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let presentedViewSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: bounds.size)
        
        let originX = (bounds.width - presentedViewSize.width) / 2
        let originY = (bounds.height - presentedViewSize.height) / 2
        
        return CGRect(x: originX, y: originY, width: presentedViewSize.width, height: presentedViewSize.height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.insertSubview(dimmingView, at: 0)
        self.dimmingView = dimmingView
    }
    
    // fast for dismis
    override func dismissalTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            dimmingView.alpha = 0.0
        }) { _ in
            dimmingView.removeFromSuperview()
        }
    }
}

class PresentationStyleManager: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
