//
//  Interger.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation



extension Int{ // timestapm int to string date
    
    func toDate(to formate: DateFormat = .medium) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = formate.rawValue
        // Set the locale to Khmer (Cambodia)
        displayFormatter.locale = Locale(identifier: "km")
        // Optionally set timezone
        displayFormatter.timeZone = TimeZone.current // or specify a specific timezone

        let formattedDate = displayFormatter.string(from: date)
        return formattedDate
    }
    
    
}
