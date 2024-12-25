//
//  ResetButton.swift
//  Overtime
//
//  Created by Jonas Frey on 14.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import JFUtils
import SwiftUI

struct ResetButton: View {
    @State private var showingResetAlert = false
    @EnvironmentObject private var userData: UserData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Button("settings.buttonLabel.reset") {
            self.showingResetAlert = true
        }
        .alert(
            "alerts.reset.title",
            isPresented: $showingResetAlert) {
                Button("alerts.actions.delete", role: .destructive) {
                    // Delete entries
                    userData.reset()
                    do {
                        try context.save()
                        try context.delete(model: Overtime.self)
                        try context.delete(model: Vacation.self)
                        try context.save()
                    } catch {
                        print(error)
                        AlertHandler.showError(title: "Error resetting data", error: error)
                    }
                }
                Button("alerts.actions.cancel", role: .cancel) {}
            } message: {
                Text("alerts.reset.message")
            }
    }
}

#Preview {
    ResetButton()
        .environmentObject(UserData())
}
