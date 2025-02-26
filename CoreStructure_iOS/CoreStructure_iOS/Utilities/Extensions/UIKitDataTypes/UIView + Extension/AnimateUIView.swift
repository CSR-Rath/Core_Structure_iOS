//
//  AnimateUIView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/2/25.
//

import Foundation
import UIKit

extension UIView {
    
    func isAnimateShow(duration: TimeInterval = 0.5) {
        self.isHidden = false // Make the view visible
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Start with small scale
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1 // Fade in
            self.transform = CGAffineTransform.identity // Reset scale to original size
        })
    }
    
    func isAnimateHide(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0 // Fade out
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Scale down while fading out
        }) { completed in
            self.isHidden = true // Hide the view after the animation
            self.transform = CGAffineTransform.identity // Reset the scale after hide
        }
    }
}
