//
//  OvertimeApp.swift
//  Overtime
//
//  Created by Jonas Frey on 27.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import SwiftUI

@main
struct OvertimeApp: App {
    
    init() {
        MigrationManager().migrate()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
        }
    }
}
