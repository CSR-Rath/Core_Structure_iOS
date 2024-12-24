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
    
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func vibrateOnWrongPassword() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Vibrated")
    }
    
    static func generateButtonFeedback(){
        let generator = UIImpactFeedbackGenerator(style: .light) // You can change the style to .medium or .heavy
        generator.prepare()
        generator.impactOccurred()
    }
}


