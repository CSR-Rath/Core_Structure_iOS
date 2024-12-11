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
