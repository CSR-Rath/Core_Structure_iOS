//
//  UIDevice.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 28/8/24.
//


import UIKit
import AudioToolbox

extension UIDevice {
    
    static func isLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    static func isiPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func vibrateOnWrongPassword() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func generateButtonFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func shakeStackView(to view: UIView , width: CGFloat = 10) {
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
    
    static func isDeviceHasSafeArea() -> Bool {
        guard let window = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first else {
            return false
        }
        
        // DeviceHasSafeArea iPhone X up
        let safeArea = window.safeAreaInsets
        return safeArea.top > 20 || safeArea.bottom > 0
    }
    
}
