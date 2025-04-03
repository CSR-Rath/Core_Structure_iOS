//
//  UIDevice.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//


import UIKit
import AudioToolbox

extension UIDevice {
    
    static let shared = UIDevice()
    
    func isLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func vibrateOnWrongPassword() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func generateButtonFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium){
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func shakeStackView(to view: UIView , width: CGFloat = 10) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        
        let fromPoint = CGPoint(x: view.center.x - width, y: view.center.y)
        let toPoint = CGPoint(x: view.center.x + width, y: view.center.y)
        
        shakeAnimation.fromValue = NSValue(cgPoint: fromPoint)
        shakeAnimation.toValue = NSValue(cgPoint: toPoint)
        
        view.layer.add(shakeAnimation, forKey: "position")
    }
}
