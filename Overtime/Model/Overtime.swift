//
//  Overtime.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftData

@Model
class Overtime: Identifiable {
    @Attribute(.unique) let id: UUID
    var date: Date
    var duration: TimeInterval
    
    init(date: Date, duration: TimeInterval) {
        self.id = UUID()
        self.date = date
        self.duration = duration
    }
    
    /// Creates a predicate that filters ``Overtime``s by the given year or month contraints
    /// - Parameters:
    ///   - year: The year to filter the ``Overtime``s by
    ///   - month: The month to filter the ``Overtime``s by (or nil to only filter by year)
    /// - Returns: A predicate that filters ``Overtime``s by the given month and optionally year
    static func predicate(for year: Int, month: Int? = nil) -> Predicate<Overtime> {
        // The start of the year/month (inclusive)
        let startDate = DateComponents(calendar: .current, year: year, month: month ?? 1).date ?? .now
        
        // The end of the year/month (exclusive)
        // If month is specified, we stay in the same year
        let endYear = month == nil ? year + 1 : year
        // Use either the next or the first month (can be > 12, DateComponents will wrap automatically)
        let endMonth = (month ?? 0) + 1
        let endDate = DateComponents(calendar: .current, year: endYear, month: endMonth).date ?? .now
        
        return #Predicate<Overtime> { overtime in
            overtime.date >= startDate && overtime.date < endDate
        }
    }
}
