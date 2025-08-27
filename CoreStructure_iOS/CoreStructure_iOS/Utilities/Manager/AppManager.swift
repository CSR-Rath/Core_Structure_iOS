//
//  AppManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 31/7/25.
//

import UIKit
import CoreLocation

class AppManager{
    
    static let shared = AppManager()
    
    func setCustomNavigationBarAppearance(
        titleColor: UIColor,
        titleColorScrolling: UIColor,
        barAppearanceColor: UIColor,
        barAppearanceScrollingColor: UIColor,
        shadowColorLine: UIColor
    ){
        let setupFont = UIFont.appFont(style: .bold, size: 16)
        let largeFont = UIFont.appFont(style: .bold, size: 24)
        
        // For non-scrolled state (standard appearance)
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = barAppearanceColor
        standardAppearance.shadowColor = shadowColorLine
        standardAppearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: setupFont
        ]
        standardAppearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: largeFont
        ]
        
        // For scrolled state (scrollEdgeAppearance)
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithOpaqueBackground()
        scrollEdgeAppearance.backgroundColor = barAppearanceScrollingColor
        scrollEdgeAppearance.shadowColor = shadowColorLine
        scrollEdgeAppearance.titleTextAttributes = [
            .foregroundColor: titleColorScrolling,
            .font: setupFont
        ]
        scrollEdgeAppearance.largeTitleTextAttributes = [
            .foregroundColor: titleColorScrolling,
            .font: largeFont
        ]
        
        // Apply both
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = standardAppearance
        navBar.scrollEdgeAppearance = scrollEdgeAppearance
        
    }
    
    func getTopMostViewController(completionHandler: @escaping (UIViewController?) -> Void) {
        guard let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: { $0.isKeyWindow })?.rootViewController else {
            completionHandler(nil)
            return
        }

        var currentViewController = rootViewController

        while let presented = currentViewController.presentedViewController {
            currentViewController = presented
        }

        completionHandler(currentViewController)
    }

    func calculateAccurateDouble(left: Double, right: Double, operation: CalculatorOperator) -> Double {
        let left = Decimal(left)
        let right = Decimal(right)
        
        var result: Decimal
        
        switch operation {
        case .add:
            result = left + right
        case .subtract:
            result = left - right
        case .multiply:
            result = left * right
        case .divide:
            if right == 0 {
                return 0 // ❌ Prevent division by zero
            }
            result = left / right
        }
        
        // ✅ Convert Decimal to Double safely
        return NSDecimalNumber(decimal: result).doubleValue
    }
    
    func statusGreetingDay() {
        
        let hour = (Calendar.current.component(.hour, from: Date()))
        
        switch hour {
        case 0..<11 :
            print(NSLocalizedString("Morning", comment: "Morning"))
        case 12..<18 :
            print(NSLocalizedString("Afternoon", comment: "Afternoon"))
        case 19..<23 :
            print(NSLocalizedString("Evening", comment: "Evening"))
            
        default:
            break
        }
    }
    
    
    func distanceKm(latitude: Double?, long: Double?, userLocation: CLLocation?) -> String{
        
        
        if let lat = latitude,
           let long = long,
           let userLocation = userLocation {
            
            let storeLocation = CLLocation(latitude: lat, longitude: long)
            let distanceInMeters = userLocation.distance(from: storeLocation)

                let distanceInKm = distanceInMeters / 1000.0
                let unit = "Km"//isKhmer ? "គីឡូម៉ែត្រ" : "km"
                let distanceText = String(format: "%.2f %@", distanceInKm, unit)
                return distanceText
            
        }else{
            return ""
        }
    }
    
    func divideDouble(_ lhs: Double,
                       _ rhs: Double ) -> Double {
         
         let left: String = String(lhs)
         let right: String = String(rhs)
         
         let a = Decimal(string: left) ?? 0
         let b = Decimal(string: right) ?? 0
         let result = a / b

         let stringValue = String(describing: result)
         
         guard let toDouble = Double(stringValue) else { return 0 }
         
         return toDouble
         
     }

    
    

}

enum CalculatorOperator {
    case add, subtract, multiply, divide
}
