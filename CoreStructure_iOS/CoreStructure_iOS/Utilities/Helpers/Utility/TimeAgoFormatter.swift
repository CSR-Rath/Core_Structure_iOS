//
//  TimeAgoFormatter.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation

//class TimeAgoFormatter {
//    private static let SECOND_MILLIS: Int64 = 1000
//    private static let MINUTE_MILLIS: Int64 = 60 * SECOND_MILLIS
//    private static let HOUR_MILLIS: Int64 = 60 * MINUTE_MILLIS
//    private static let DAY_MILLIS: Int64 = 24 * HOUR_MILLIS
//
//    static func getTimeAgo(time: Int64?) -> String {
//        guard let time = time else { return "" }
//
//        var valueTime = time
//        if time < 1000000000000 {
//            valueTime *= 1000
//        }
//
//        let now = Int64(Date().timeIntervalSince1970 * 1000)
//        if time > now || valueTime <= 0 {
//            return ""
//        }
//
//        let diff = now - valueTime
//        if diff < MINUTE_MILLIS {
//            return "just now"
//        } else if diff < 2 * MINUTE_MILLIS {
//            return "a minute ago"
//        } else if diff < 50 * MINUTE_MILLIS {
//            return "\(diff / MINUTE_MILLIS) minutes ago"
//        } else if diff < 90 * MINUTE_MILLIS {
//            return "an hour ago"
//        } else if diff < 24 * HOUR_MILLIS {
//            return "\(diff / HOUR_MILLIS) hours ago"
//        } else if diff < 48 * HOUR_MILLIS {
//            return "yesterday"
//        } else {
//            return "\(diff / DAY_MILLIS) days ago"
//        }
//    }
//}


class TimeAgoFormatter {
    private static let millisecondsPerSecond: Int64 = 1000
    private static let millisecondsPerMinute: Int64 = 60 * millisecondsPerSecond
    private static let millisecondsPerHour: Int64 = 60 * millisecondsPerMinute
    private static let millisecondsPerDay: Int64 = 24 * millisecondsPerHour

    static func formattedTimeAgo(from timestamp: Int64?) -> String {
        guard let timestamp = timestamp else { return "" }

        var timestampInMillis = timestamp
        if timestamp < 1_000_000_000_000 { // Convert seconds to milliseconds if needed
            timestampInMillis *= 1000
        }

        let currentTimeInMillis = Int64(Date().timeIntervalSince1970 * 1000)
        let timeDifference = currentTimeInMillis - timestampInMillis

        guard timeDifference > 0 else { return "" }

        switch timeDifference {
        case 0..<millisecondsPerMinute:
            return "just now"
        case millisecondsPerMinute..<2 * millisecondsPerMinute:
            return "a minute ago"
        case 2 * millisecondsPerMinute..<50 * millisecondsPerMinute:
            return "\(timeDifference / millisecondsPerMinute) minutes ago"
        case 50 * millisecondsPerMinute..<90 * millisecondsPerMinute:
            return "an hour ago"
        case 90 * millisecondsPerMinute..<24 * millisecondsPerHour:
            return "\(timeDifference / millisecondsPerHour) hours ago"
        case 24 * millisecondsPerHour..<48 * millisecondsPerHour:
            return "yesterday"
        default:
            return "\(timeDifference / millisecondsPerDay) days ago"
        }
    }
}
