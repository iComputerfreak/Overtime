//
//  MigrationView.swift
//  Overtime
//
//  Created by Jonas Frey on 04.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftUI

struct MigrationView: View {
    @Environment(\.modelContext) private var context
    
    @State private var showingError = false
    @State private var error: Error?
    
    var body: some View {
        ProgressView {
            Text("migration.progressText")
        }
        .onAppear {
            migrateLegacyData()
        }
        .alert("migration.alert.errorTitle", isPresented: $showingError, actions: {
            Button("alert.okButton") {}
        }, message: {
            Text("migration.alert.errorMessage \(error?.localizedDescription ?? "")")
        })
    }
    
    func migrateLegacyData() {
        // Read data from UserDefaults
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.legacyOvertimesKey) as? Data else {
            // There is no legacy data. We are done.
            UserDefaults.standard.set(true, forKey: JFUtils.legacyMigrationKey)
            return
        }
        do {
            // Deocde the list of overtimes from the plist data
            let overtimes = try PropertyListDecoder().decode([LegacyOvertime].self, from: plist)
            // Map them to real overtimes and insert them into the context
            overtimes.forEach { legacyOvertime in
                let duration = legacyOvertime.duration
                let timeInterval = Double((duration.negative ? -1 : 1) * duration.seconds)
                let overtime = Overtime(date: legacyOvertime.date, duration: timeInterval)
                self.context.insert(overtime)
            }
            // Delete the old values
            UserDefaults.standard.removeObject(forKey: JFUtils.legacyOvertimesKey)
            UserDefaults.standard.set(true, forKey: JFUtils.legacyMigrationKey)
        } catch {
            print("Error during legacy migration.")
            print(error)
            self.error = error
            self.showingError = true
        }
    }
    
    private struct LegacyOvertime: Decodable {
        let date: Date
        let duration: Duration
        
        struct Duration: Decodable {
            let seconds: Int
            let negative: Bool
        }
    }
}

#Preview {
    MigrationView()
}
