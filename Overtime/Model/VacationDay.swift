// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation
import SwiftData

@Model
class Vacation: Identifiable, ObservableObject {
    var id: UUID = UUID()
    /// The title of the vacation entry
    var title: String? = nil
    /// When the vacation starts
    var startDate: Date = Date.now
    /// How long the vacation lasts (in seconds)
    var duration: TimeInterval = 0
    /// How many vacation days were used up for this vacation
    var daysUsed: Double = 0
    
    var endDate: Date {
        startDate.addingTimeInterval(duration)
    }
    
    init(title: String? = nil, startDate: Date, duration: TimeInterval, daysUsed: Double) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.duration = duration
        self.daysUsed = daysUsed
    }
    
    convenience init(title: String? = nil, startDate: Date, endDate: Date, daysUsed: Double) {
        let duration = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        self.init(title: title, startDate: startDate, duration: duration, daysUsed: daysUsed)
    }
    
    /// Creates a predicate that filters ``Vacation``s by the given year contraints
    /// - Parameters:
    ///   - year: The year to filter the ``Vacation``s by
    /// - Returns: A predicate that filters ``Vacation``s by the given year. A vacation matches the given year if its start date lies within that year.
    static func predicate(for year: Int) -> Predicate<Vacation> {
        // The start of the year (inclusive)
        let startDate = DateComponents(calendar: .current, year: year).date ?? .now
        // The end of the year (exclusive)
        let endDate = DateComponents(calendar: .current, year: year + 1).date ?? .now
        
        return #Predicate<Vacation> { vacation in
            vacation.startDate >= startDate && vacation.startDate < endDate
        }
    }
}
