//
//  Extensions.swift
//  Overtime
//
//  Created by Jonas Frey on 15.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import Foundation

extension Calendar {
    static var utc: Calendar {
        var c = Calendar.current
        c.timeZone = .utc
        return c
    }
}

extension TimeZone {
    static let utc = TimeZone(secondsFromGMT: 0)!
}

extension Date {
    
    subscript(_ component: Calendar.Component) -> Int {
        get {
            Calendar.utc.component(component, from: self)
        }
        set {
            self = Calendar.utc.date(bySetting: component, value: newValue, of: self)!
        }
    }
    
    
    
    public static func create(year: Int, month: Int = 1, day: Int = 1) -> Date {
        return Calendar.utc.date(from: DateComponents(year: year, month: month, day: day))!
    }
    
    func timeIntervalUntilMidnight() -> TimeInterval {
        var midnight = Calendar.utc.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
        midnight.addTimeInterval(.day)
        return midnight.timeIntervalSince(self)
    }
    
    func numberOfDaysInMonth() -> Int {
        let nextMonth = Calendar.utc.nextDate(after: self, matching: .init(day: 1), matchingPolicy: .nextTime)!
        let lastDay = Calendar.utc.date(byAdding: .day, value: -1, to: nextMonth)!
        return lastDay[.day]
    }
    
}

extension TimeInterval {
    static var minute: TimeInterval { 60 }
    static var hour: TimeInterval { minute * 60 }
    static var day: TimeInterval { hour * 24 }
}
