//
//  TimeAgoFormatter.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation


class TimestampManager {
    
    // MARK: - Time Constants (in milliseconds)
    private static let msPerSecond: Int64 = 1_000
    private static let msPerMinute: Int64 = 60 * msPerSecond
    private static let msPerHour: Int64 = 60 * msPerMinute
    private static let msPerDay: Int64 = 24 * msPerHour

    /// Formats a timestamp as "just now", "2 minutes ago", "yesterday", or a full date.
    static func timeAgo(from timestampMillisOrSeconds: Int64?,
                        dateFormat: String = "dd/MM/yyyy") -> String {
        guard var timestamp = timestampMillisOrSeconds else { return "" }

        // Convert to milliseconds if input looks like seconds
        if timestamp < 1_000_000_000_000 {
            timestamp *= 1_000
        }

        let now = Int64(Date().timeIntervalSince1970 * 1_000)
        let elapsed = now - timestamp

        guard elapsed > 0 else { return "" }

        switch elapsed {
        case 0..<msPerMinute:
            return "Just now"
        case msPerMinute..<2 * msPerMinute:
            return "a minute ago"
        case 2 * msPerMinute..<50 * msPerMinute:
            return "\(elapsed / msPerMinute) minutes ago"
        case 50 * msPerMinute..<90 * msPerMinute:
            return "an hour ago"
        case 90 * msPerMinute..<msPerDay:
            return "\(elapsed / msPerHour) hours ago"
        case msPerDay..<2 * msPerDay:
            return "yesterday"
        default:
            // Return formatted date for older timestamps
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1_000)
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            return formatter.string(from: date)
        }
    }
}
