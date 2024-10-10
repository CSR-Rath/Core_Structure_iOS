//
//  TimeAgoFormatter.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation

class TimeAgoFormatter {
    private static let SECOND_MILLIS: Int64 = 1000
    private static let MINUTE_MILLIS: Int64 = 60 * SECOND_MILLIS
    private static let HOUR_MILLIS: Int64 = 60 * MINUTE_MILLIS
    private static let DAY_MILLIS: Int64 = 24 * HOUR_MILLIS

    static func getTimeAgo(time: Int64?) -> String {
        guard let time = time else { return "" }

        var valueTime = time
        if time < 1000000000000 {
            valueTime *= 1000
        }

        let now = Int64(Date().timeIntervalSince1970 * 1000)
        if time > now || valueTime <= 0 {
            return ""
        }

        let diff = now - valueTime
        if diff < MINUTE_MILLIS {
            return "just now"
        } else if diff < 2 * MINUTE_MILLIS {
            return "a minute ago"
        } else if diff < 50 * MINUTE_MILLIS {
            return "\(diff / MINUTE_MILLIS) minutes ago"
        } else if diff < 90 * MINUTE_MILLIS {
            return "an hour ago"
        } else if diff < 24 * HOUR_MILLIS {
            return "\(diff / HOUR_MILLIS) hours ago"
        } else if diff < 48 * HOUR_MILLIS {
            return "yesterday"
        } else {
            return "\(diff / DAY_MILLIS) days ago"
        }
    }
}
