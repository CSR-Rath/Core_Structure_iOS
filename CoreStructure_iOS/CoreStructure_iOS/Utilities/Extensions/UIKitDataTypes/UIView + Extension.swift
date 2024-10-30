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

extension UIView{
    
    func isHasSafeAreaInsets() -> Bool {
        
        // Check if any of the insets are greater than zero
        if self.safeAreaInsets.top > 0 {
            return true
        }else{
            return false
        }
    }
    
    //MARK: calculate text label width
    func calculateLabelWidth(text: String, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }

}

//MARK: Handle addGestureRecognizer have param UIView
extension UIView{
    
    func addGestureRecognizer(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Ensure user interaction is enabled
    }
}

//MARK: Handle cornerRadius
extension UIView{
    enum RoundCornersAt{
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    //multiple corners using CACornerMask
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
}


//MARK: Handle UITapGestureRecognizer and UIPanGestureRecognizer
extension UIView {
    
    static var didTapGesture:(()->())?
    static var dropHeight: CGFloat = 200 // Dismiss view contoller
    
    // Adds a tap gesture recognizer to dismiss the view
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelDismiss))
        self.addGestureRecognizer(tapGesture)
    }
    
    // Adds a pan gesture recognizer to a specified control view
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            // Move the view with the gesture
            if translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            print("translation.y ===> \(translation.y)")
            
            // Dismiss the view if the swipe is downward
            if translation.y > UIView.dropHeight {
                cancelDismiss()
            } else {
                // Reset position
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    @objc private func cancelDismiss() {
        // Dismissal logic
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
        
        UIView.didTapGesture?()
    }
}
