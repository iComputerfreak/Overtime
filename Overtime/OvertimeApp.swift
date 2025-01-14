//
//  OvertimeApp.swift
//  Overtime
//
//  Created by Jonas Frey on 27.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

@main
struct OvertimeApp: App {
    
    @AppStorage(JFUtils.legacyMigrationKey) private var legacyMigrationComplete: Bool = false
    
    var needsLegacyMigration: Bool {
        // If there is no migration key set and the data is non-empty, we need to migrate
        return !legacyMigrationComplete && !(UserDefaults.standard.data(forKey: JFUtils.legacyOvertimesKey)?.isEmpty ?? true)
    }
    
    let modelContainer: ModelContainer = {
        #if DEBUG
        // Handle screenshot sample data
        if ProcessInfo.processInfo.arguments.contains("--screenshots") {
            // Use the preview container for the screenshots
            return previewContainer
        }
        #endif
        
        do {
            let config = ModelConfiguration(cloudKitDatabase: .automatic)
            return try ModelContainer(for: Overtime.self, Vacation.self, configurations: config)
        } catch {
            fatalError("Failed to create model container!")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: .constant(needsLegacyMigration)) {
                    MigrationView()
                        .interactiveDismissDisabled()
                }
                .modelContainer(modelContainer)
                .environmentObject(UserData())
        }
    }
}
