//
//  JFUtils.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct JFUtils {
    static let overtimesKey = "overtimes"
    static let monthCollapseStatesKey = "monthCollapseStates"
    static let weekCollapseStatesKey = "weekCollapseStates"
    
    static var overtimesInvalidated = false
    
    static func timeString(_ duration: Duration) -> String {
        let sign = "\(duration.negative ? "-" : "")"
        // 1h
        if duration.minutes % 60 == 0 {
            return "\(sign)\(duration.hours)h"
        }
        // 10m
        if duration.hours == 0 {
            return "\(sign)\(duration.minutes)m"
        }
        // 1h 10m
        return "\(sign)\(duration.hours)h \(duration.minutes % 60)m"
    }
}
