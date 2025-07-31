//
//  UIColor.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import UIKit

func a (){
    
    UserDefaults.standard.set(AppearanceMode.dark.rawValue, forKey: AppConstants.appearanceMode)
    UserDefaults.standard.set(AppearanceMode.light.rawValue, forKey: AppConstants.appearanceMode)
    
}


enum AppearanceMode: String {
    case light = "Light Mode"
    case dark = "Dark Mode"

    static var current: AppearanceMode {
        guard let appearanceMode = UserDefaults.standard.string(forKey: AppConstants.appearanceMode) else {
            print("AppearanceMode is nil.")
            return .light
        }
        return AppearanceMode(rawValue: appearanceMode) ?? .light
    }
}


extension UIColor {

    static var backgroundColor: UIColor {
        switch AppearanceMode.current {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
    // text

    static var editColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)  //0A59D4
    static var addColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)  //0A59D4
    static var deleteColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)  //0A59D4
    static var mainBlueColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)  //0A59D4
    static var mainTxtColor = #colorLiteral(red: 0.1756211619, green: 0.5514567086, blue: 0.7638746319, alpha: 1)  //98C6E7
    static var mainBGColor = #colorLiteral(red: 0.8533408605, green: 0.9960435564, blue: 0.9997980137, alpha: 1)  //98C6E7
    static var mainColorw = #colorLiteral(red: 0.7333333333, green: 0.737254902, blue: 0.7450980392, alpha: 1)  //0A59D4
    static var mainLightColor = #colorLiteral(red: 0.2061504722, green: 0.2724969983, blue: 0.314096868, alpha: 1)//38454F
    static var mainColor = #colorLiteral(red: 0.118264921, green: 0.189347744, blue: 0.2359016538, alpha: 1)  // #1F303C
    static var mainGray = #colorLiteral(red: 0.3529411765, green: 0.3764705882, blue: 0.4431372549, alpha: 1) // #5A6071
    static var mainYellow = #colorLiteral(red: 0.9450980392, green: 0.7450980392, blue: 0.2823529412, alpha: 1) // #F1BE48
    static var mainRed = #colorLiteral(red: 0.9985015988, green: 0.3468284607, blue: 0.2801859975, alpha: 1) //#FF5847
    static var mainTabBarColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1) //#FF5847
    
    
    //MARK: - Hax Color
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
       var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
       
       if cString.hasPrefix("#") { cString.removeFirst() }
       
       if cString.count != 6 {
         self.init("ff0000") // return red color for wrong hex input
         return
       }
       
       var rgbValue: UInt64 = 0
       Scanner(string: cString).scanHexInt64(&rgbValue)
       
       self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                 alpha: alpha)
     }
    
    //MARK: - Covert UIcolor to HexCode
    var covertHexCode: String {
          get{
              let colorComponents = self.cgColor.components!
              if colorComponents.count < 4 {
                  return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[0]*255.0),Int(colorComponents[0]*255.0)).uppercased()
              }
              return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[1]*255.0),Int(colorComponents[2]*255.0)).uppercased()
          }
      }

}


