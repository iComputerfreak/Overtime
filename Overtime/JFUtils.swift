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
    
    static var overtimesInvalidated = false
    
    static func timeString(_ duration: Duration) -> String {
        // 1h
        if duration.minutes % 60 == 0 {
            return "\(duration.hours)h"
        }
        // 10m
        if duration.hours == 0 {
            return "\(duration.minutes)m"
        }
        // 1h 10m
        return "\(duration.hours)h \(duration.minutes % 60)m"
    }
}
