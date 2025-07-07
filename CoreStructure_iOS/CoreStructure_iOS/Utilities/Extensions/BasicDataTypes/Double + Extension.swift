//
//  Double.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum FormatTypeEnum {
    
    case currencyAsKHR
    case currencyAsUSD
    case asLiters
    case asPoints
    
    case currencyKHR
    case currencyUSD
    case liters
    case points
}

enum CurrencyCodeEnum: String{
    case currencyKHR = "KHR"
    case currencyUSD = "USD"
}

extension Double {
    
    func toFormate(as type: FormatTypeEnum, currencyCodeAfterAmount: Bool = true) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.locale = Locale(identifier: "en_US")

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
        
       let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? "0"
        
        return currencyCodeAfterAmount ? "\(formattedValue) \(suffix)" : "\(suffix) \(formattedValue)"
    }
    
    func toCurrency(
        for currency: CurrencyCodeEnum,
        includeCurrencyCode: Bool = true,
        currencyCodeAfterAmount: Bool = true
    ) -> String{
    
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.locale = Locale(identifier: "en_US")

        
        var suffix = ""

        switch currency {
        case .currencyKHR:
          
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            
            if includeCurrencyCode{
                suffix = "KHR".localizeString()
            }
            
        case .currencyUSD:

            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            if includeCurrencyCode{
                suffix = "USD".localizeString()
            }
        }
        
       let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? "0"
        
        return currencyCodeAfterAmount ? "\(formattedValue) \(suffix)" : "\(suffix) \(formattedValue)"
        
    }
    
}
