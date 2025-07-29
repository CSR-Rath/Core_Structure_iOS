//
//  DayManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 22/10/24.
//

import Foundation
import UIKit

class DayManager{
    
    static func statusGreetingDay() {
        
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
}


