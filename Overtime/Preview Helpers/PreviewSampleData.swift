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
            for: Overtime.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        Task { @MainActor in
            let context = container.mainContext
            
            context.insert(Overtime(date: .now, duration: 2.5 * .hour))
            context.insert(Overtime(date: .now.addingTimeInterval(-1 * .day), duration: 1.5 * .hour))
        }
        
        return container
    } catch {
        fatalError("Failed to create a preview model container: \(error)")
    }
}()
