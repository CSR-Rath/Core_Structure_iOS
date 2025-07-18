//
//  Double.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum FormateTypeEnum{
    case KHR
    case USD
    case POINTS
    case LISTERS
    
    
    case TYPE_KHR
    case TYPE_USD
    case TYPE_POINS
    case TYPE_LISTERS
    
    case KHR_TYPE
    case USD_TYPE
    case POINTS_TYPE
    case LISTERS_TYPE
    
    
}


extension Double {
    
    func toFormate(as type: FormateTypeEnum) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.locale = Locale(identifier: "en_US")

        var suffix = ""

        switch type {
        case .KHR, .KHR_TYPE, .TYPE_KHR:
          
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            
            if type != .KHR{
                suffix = "KHR".localizeString()
            }
            
        case .USD, .USD_TYPE, .TYPE_USD:
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            if type != .USD{
                suffix = "USD".localizeString()
            }

        case .LISTERS, .LISTERS_TYPE, .TYPE_LISTERS:
            numberFormatter.roundingMode = .floor
            numberFormatter.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
            
            if type != .LISTERS{
                suffix = self > 1 ? "Liters".localizeString() : "Liter".localizeString()
            }

        case .POINTS, .POINTS_TYPE, .TYPE_POINS:
            numberFormatter.roundingMode = .floor
            numberFormatter.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
            
            if type != .POINTS{
                suffix = self > 1 ? "Points".localizeString() : "Point".localizeString()
            }
        }
        
       let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? "0"
        
        if type == .KHR_TYPE ||
            type == .USD_TYPE ||
            type == .POINTS_TYPE ||
            type == .LISTERS_TYPE {
            
            return "\(formattedValue) \(suffix)"
            
        }else if type == .TYPE_KHR ||
                    type == .TYPE_USD ||
                    type == .TYPE_POINS ||
                    type == .TYPE_LISTERS {
            return "\(suffix) \(formattedValue)"
        }else{
            return formattedValue
        }
    }
}
