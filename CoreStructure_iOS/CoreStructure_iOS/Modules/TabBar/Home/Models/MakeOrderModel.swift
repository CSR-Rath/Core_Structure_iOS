//
//  MakeOrderModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/4/25.
//

import Foundation
import UIKit

struct ProductModel {
    let name: String
    let amount: Double
    let qty: Int
}

struct MakeOrderModel {
    var customerName: String
    var phoneNumber: String
    var created: Int
    var products: [ProductModel]
    var delivery: Double
    var location: String
}
