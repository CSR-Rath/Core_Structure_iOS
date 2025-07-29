//
//  CalculatorManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 29/7/25.
//

import Foundation


enum CalculatorOperator {
    case add, subtract, multiply, divide
}

class CalculatorManager{
    
   static func calculateAccurateDouble(_ lhs: Double, _ rhs: Double, operation: CalculatorOperator) -> Double {
        let left = Decimal(lhs)
        let right = Decimal(rhs)
        
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
}


