//
//  JFUtils.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct JFUtils {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }()
    
    static let zeroDurationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour]
        f.unitsStyle = .abbreviated
        return f
    }()
    
    static let legacyOvertimesKey = "overtimes"
    static let legacyMigrationKey = "legacyMigrationComplete"
    
    static func timeString(_ duration: TimeInterval) -> String {
        let durationStart = Date(timeIntervalSince1970: 0)
        let durationEnd = durationStart.addingTimeInterval(duration)
        
        // If the duration is zero, we want to display '0h' instead of '0m'
        let formatter = duration < 1 ? zeroDurationFormatter : durationFormatter
        return formatter.string(from: durationStart, to: durationEnd) ?? ""
    }
}
