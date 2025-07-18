//
//  Board.swift
//  LOS
//
//  Created by Rath! on 11/9/24.
//

import Foundation

class Board: Codable {
    
    var title: String
    var items: [String]
    
    init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
}
