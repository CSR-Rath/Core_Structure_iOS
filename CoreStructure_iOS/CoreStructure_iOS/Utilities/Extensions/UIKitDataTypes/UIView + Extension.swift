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
    

    
    func addGestureRecognizer(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // Ensure user interaction is enabled
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
