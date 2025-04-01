//
//  Interger.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 26/8/24.
//

import Foundation

enum DateFormatEnum: String {
    case fullDate = "yyyy-MM-dd HH:mm:ss"
    case shortDate = "yyyy-MM-dd"
    case timeOnly = "HH:mm:ss"
    case monthDayYear = "MM/dd/yyyy"
    case dayMonthYear = "dd/MM/yyyy"
    case fullMonthDayYear = "MMMM dd, yyyy"
    case weekdayFull = "EEEE, MMMM d, yyyy"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
}



extension Int{ // timestapm int to string date
    
    
    func toDate() -> String{
        
        let date = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MMMM-yyyy"
        displayFormatter.locale = Locale(identifier: getLanguageType())
        let formattedDate = displayFormatter.string(from: date)
        
        return formattedDate
    }
    
    func dateFromMilliseconds(format: DateFormatEnum) -> String {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: getLanguageType())
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone.current
        
        let timeStamp = dateFormatter.string(from: date as Date)
        return ( timeStamp )
        
    }
    
    
}
