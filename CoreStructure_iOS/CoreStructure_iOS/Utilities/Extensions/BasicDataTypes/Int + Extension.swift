//
//  Interger.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum DateFormatStyle: String {
    
    // MARK: - Standard Formats
    case fullDateTime = "yyyy-MM-dd HH:mm:ss"              // 2025-06-03 14:45:00
    case shortDate = "yyyy-MM-dd"                          // 2025-06-03
    case timeOnly = "HH:mm:ss"                             // 14:45:00
    case timeHourMinute = "HH:mm"                          // 14:45

    // MARK: - US Formats
    case monthDayYear = "MM/dd/yyyy"                       // 06/03/2025
    case monthDayYearTime = "MM/dd/yyyy HH:mm"             // 06/03/2025 14:45
    case fullMonthDayYear = "MMMM dd, yyyy"                // June 03, 2025
    case weekdayFull = "EEEE, MMMM d, yyyy"                // Tuesday, June 3, 2025

    // MARK: - EU Formats
    case dayMonthYear = "dd/MM/yyyy"                       // 03/06/2025
    case dayMonthYearTime = "dd/MM/yyyy HH:mm"             // 03/06/2025 14:45

    // MARK: - ISO Formats
    case iso8601Full = "yyyy-MM-dd'T'HH:mm:ssZ"            // 2025-06-03T14:45:00+0000
    case iso8601NoTimezone = "yyyy-MM-dd'T'HH:mm:ss"       // 2025-06-03T14:45:00

    // MARK: - Custom Formats
    case yearMonth = "yyyy-MM"                             // 2025-06
    case monthYear = "MMMM yyyy"                           // June 2025
    case fullDateWithWeekday = "EEEE, dd MMMM yyyy"        // Tuesday, 03 June 2025
    case numericDateTime = "dd-MM-yyyy HH:mm"              // 03-06-2025 14:45
    case compact = "yyyyMMdd"                              // 20250603
    case logFormat = "yyyy-MM-dd HH:mm:ss.SSS"             // 2025-06-03 14:45:00.123

    // MARK: - Chat/Message Formats
    case chatTimestamp = "h:mm a"                          // 2:45 PM
    case chatDateHeader = "EEEE, MMM d"                    // Tuesday, Jun 3
}


extension Int{ // timestapm int to string date
    
    func toDate() -> String{
        
        let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MMMM-yyyy"
        displayFormatter.locale = Locale(identifier: LanguageManager.shared.getCurrentLanguage().rawValue)
        let formattedDate = displayFormatter.string(from: date)
        
        return formattedDate
    }
    
    func dateFromMilliseconds(format: DateFormatStyle) -> String {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LanguageManager.shared.getCurrentLanguage().rawValue)
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone.current
        
        let timeStamp = dateFormatter.string(from: date as Date)
        return ( timeStamp )
        
    }
    
    
}
