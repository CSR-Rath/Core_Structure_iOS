//
//  Interger.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum DateFormat: String {
    
    case time = "h:mm a"  /// Time format (e.g., 5:30 PM)
   
    case short = "dd-MM-yyyy"  /// Short date format (e.g., 31/12/2023)
    case shortSlash = "dd/MM/yyyy"  /// Short date format (e.g., 31/12/2023)
 
    case medium = "dd-MMMM-yyyy"   /// Medium date format (e.g., 31-December-2023)
    case mediumSlash = "dd/MMMM/yyyy"   /// Medium date format (e.g., 31-December-2023)

    case long = "EEEE, dd MMMM yyyy"  /// Long date format (e.g., Sunday, 31 December 2023)
    case full = "EEEE, dd MMMM yyyy h:mm a"  /// Full date and time format (e.g., Sunday, 31 December 2023 5:30 PM)
}


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
