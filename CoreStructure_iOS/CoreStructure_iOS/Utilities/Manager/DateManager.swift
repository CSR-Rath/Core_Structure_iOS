//
//  DateHelper.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation


class DateManager {
    static let shared = DateManager()

    private init() {}

    // MARK: - Date Formatting

    func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }


    func timeIntervalInDays(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }

    func timeIntervalInHours(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: startDate, to: endDate)
        return components.hour ?? 0
    }

    func timeIntervalInMinutes(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: startDate, to: endDate)
        return components.minute ?? 0
    }

    // MARK: - Date Manipulation

    func addDays(_ days: Int, to date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: date) ?? date
    }

    func addHours(_ hours: Int, to date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: hours, to: date) ?? date
    }

    func addMinutes(_ minutes: Int, to date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: minutes, to: date) ?? date
    }
}
