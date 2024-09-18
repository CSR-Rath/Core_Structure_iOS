//
//  UIColor.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/8/24.
//

import Foundation
import UIKit


extension UIColor {
    
    static var mainColor = #colorLiteral(red: 0.03921568627, green: 0.3490196078, blue: 0.831372549, alpha: 1)  //0A59D4
  
    
    //MARK: Hax Color
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
    
    //Covert UIcolor to HexCode
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
