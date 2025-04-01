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


//MARK: Double
//extension Double {
//    
//    var toCurrencyAsKHR : String{
//        let currencyCode = "KHR"
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.minimumFractionDigits = 2
//        numberFormatter.maximumFractionDigits = (currencyCode == "USD") ? 2 : 0
//        numberFormatter.groupingSeparator = "," // Separator for thousands
//        numberFormatter.decimalSeparator = "." // Separator for decimals
//        
//        let locale = Locale(identifier: "en_US") // Example: United States
//        numberFormatter.locale = locale
//        
//        let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? ""
//        
//        let separatedValue = formattedValue.replacingOccurrences(of: ",", with: ",")
//        var currencyWithCode = "\(currencyCode) \(separatedValue)"
//        if getLanguageType() != "en"{
//            currencyWithCode = "\(separatedValue) រៀល"
//        }
//        return currencyWithCode
//    }
//    
//    var toCurrencyAsUSD : String{
//        
//        let currencyCode = "USD"
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.roundingMode = .halfUp
//        numberFormatter.minimumFractionDigits = 2
//        numberFormatter.maximumFractionDigits = 2
//        numberFormatter.groupingSeparator = "," // Separator for thousands
//        numberFormatter.decimalSeparator = "." // Separator for decimals
//        
//        let locale = Locale(identifier: "en_US") // Example: United States
//        numberFormatter.locale = locale
//        
//        let formattedValue = numberFormatter.string(from: NSNumber(value: self)) ?? ""
//        
//        let separatedValue = formattedValue.replacingOccurrences(of: ",", with: ",")
//        var currencyWithCode = "\(separatedValue) \(currencyCode)"
//        
//        if  getLanguageType() != "en"{
//            currencyWithCode = "\(separatedValue) ដុល្លារ"
//        }
//        
//        return currencyWithCode
//    }
   
//}


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
        return formatCurrency(currencyCode: "KHR", localeIdentifier: "km_KH", isLocalized: getLanguageType() != "en")
    }
    
    var toCurrencyAsUSD: String {
        return formatCurrency(currencyCode: "USD", localeIdentifier: "en_US", isLocalized: getLanguageType() != "en")
    }
}
