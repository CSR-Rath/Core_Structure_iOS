//
//  UIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import UIKit

//MARK: for animate show heide
extension UIView{
    
    func animateShow(duration: TimeInterval = 0.5) {
        self.isHidden = false // Make the view visible
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1 // Fade in
        })
    }
    
    func animateHide(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0 // Fade out
        }) { completed in
            self.isHidden = true // Hide the view after the animation
        }
    }
}

//MARK: For action on UIView
extension UIView{
    
    static var didTapGesture:(()->())?
    
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Ensure user interaction is enabled
    }
    
    @objc private func handleTap() {
        UIView.didTapGesture?()
        print("View tapped!")
    }
}
