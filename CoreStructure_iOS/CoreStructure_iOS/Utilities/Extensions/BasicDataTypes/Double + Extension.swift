//
//  Double.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum FormatType {
    
    case currencyAsKHR
    case currencyAsUSD
    case asLiters
    case asPoints
    
    //MARK: - Raw values only (no suffixes)
    case currencyKHR
    case currencyUSD
    case liters
    case points
}

extension Double {
    
    func formattedString(as type: FormatType, isSuffixAfterValue: Bool = true) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.locale = Locale(identifier: "en_US")

        var formattedValue = ""
        var suffix = ""

        switch type {
        case .currencyAsKHR, .currencyKHR:
          
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            
            if type == .currencyAsKHR{
                suffix = "KHR".localizeString()
            }
            
        case .currencyAsUSD, .currencyUSD:

            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            if type == .currencyAsUSD{
                suffix = "USD".localizeString()
            }

        case .asLiters, .liters:
            numberFormatter.roundingMode = .floor
            numberFormatter.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
            
            if type == .asLiters{
                suffix = self > 1 ? "Liters".localizeString() : "Liter".localizeString()
            }

        case .asPoints, .points:
            numberFormatter.roundingMode = .floor
            numberFormatter.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
            
            if type == .asPoints{
                suffix = self > 1 ? "Points".localizeString() : "Point".localizeString()
            }
        }
        
        formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? "0"
        
        return isSuffixAfterValue ? "\(formattedValue) \(suffix)" : "\(suffix) \(formattedValue)"
    }
}
