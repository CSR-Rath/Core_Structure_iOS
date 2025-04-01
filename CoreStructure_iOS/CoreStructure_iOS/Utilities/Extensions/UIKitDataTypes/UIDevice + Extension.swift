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
}



