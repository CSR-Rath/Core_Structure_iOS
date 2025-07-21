//
//  APITheSameModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 21/7/25.
//

import Foundation

struct APITheSameModel: Codable {
    var page: Int?
    var size: Int?
    var total: Int?
    var totalPage: Int?
    var response: ResponseModel?
    var results: [String]?
}
