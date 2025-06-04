//
//  Double.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

extension Double{
    
    func twoDigit(sign: String = "")->String{
        let formattedNumber = String(format: "%.2f", self)
        return sign + " " + formattedNumber
    }
    
}




extension Double {
    
    private func formatCurrency(currencyCode: String, 
                                localeIdentifier: String,
                                isLocalized: Bool) -> String {
        // Set up number formatter
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = (currencyCode == "USD") ? 2 : 0
        numberFormatter.maximumFractionDigits = (currencyCode == "USD") ? 2 : 0
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        
        let locale = Locale(identifier: localeIdentifier)
        numberFormatter.locale = locale
        
        let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        
        // Replace commas
        let separatedValue = formattedValue.replacingOccurrences(of: ",", with: ",")
        
        // Format with the currency code or localized name
        var currencyWithCode = "\(currencyCode) \(separatedValue)"
        
        if isLocalized {
            switch currencyCode {
            case "KHR":
                currencyWithCode = "\(separatedValue) រៀល"
            case "USD":
                currencyWithCode = "\(separatedValue) ដុល្លារ"
            default:
                break
            }
        }
        
        return currencyWithCode
    }
    
    var toCurrencyAsKHR: String {
        return formatCurrency(currencyCode: "KHR", localeIdentifier: "km_KH", isLocalized: LanguageManager.shared.getLanguageType() != "en")
    }
    
    var toCurrencyAsUSD: String {
        return formatCurrency(currencyCode: "USD", localeIdentifier: "en_US", isLocalized: LanguageManager.shared.getLanguageType() != "en")
    }
    var toLiter: String {
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .decimal
         numberFormatter.minimumFractionDigits = 2
         numberFormatter.maximumFractionDigits = 2
         numberFormatter.groupingSeparator = ","
         numberFormatter.decimalSeparator = "."
         
         let formatted = numberFormatter.string(from: NSNumber(value: self)) ?? "0.00"
         return "\(formatted) L"
     }
}
