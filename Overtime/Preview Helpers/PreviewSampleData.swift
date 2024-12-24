//
//  PreviewSampleData.swift
//  Overtime
//
//  Created by Jonas Frey on 29.09.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftData

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Overtime.self, Vacation.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        Task { @MainActor in
            let context = container.mainContext
            
            context.insert(Overtime(date: .now, duration: 2.5 * .hour))
            context.insert(Overtime(date: .now.addingTimeInterval(-1 * .day), duration: 1.5 * .hour))
            
            context.insert(Vacation(title: "Christmas", startDate: .now, duration: 5 * .day, daysUsed: 5))
            context.insert(Vacation(title: "Summer trip", startDate: .now, duration: 20 * .day, daysUsed: 15))
            context.insert(Vacation(startDate: .now.addingTimeInterval(-4 * .day), duration: 4 * .day, daysUsed: 0))
            context.insert(Vacation(title: "Top up 2025", startDate: DateComponents(calendar: .current, year: 2024).date!, duration: 0, daysUsed: -28))
        }
        
        return container
    } catch {
        fatalError("Failed to create a preview model container: \(error)")
    }
}()

private extension Vacation {
    convenience init(title: String? = nil, startDate: Date, duration: TimeInterval, daysUsed: Double) {
        self.init(title: title, startDate: startDate, endDate: startDate.addingTimeInterval(duration), daysUsed: daysUsed)
    }
}
