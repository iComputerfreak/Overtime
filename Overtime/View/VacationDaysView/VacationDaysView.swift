// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftData
import SwiftUI

struct VacationDaysViewConfig {
    var editingItem: Vacation?
    var newlyCreated: Bool = false
    var showingEditingView: Bool = false
    var showingTopUpView: Bool = false
    
    @MainActor
    mutating func presentEditingSheet(_ editingItem: Vacation, newlyCreated: Bool) {
        if editingItem.daysUsed < 0 {
            presentTopUpSheet(editingItem, newlyCreated: newlyCreated)
            return
        }
        self.editingItem = editingItem
        self.newlyCreated = newlyCreated
        self.showingEditingView = true
    }
    
    @MainActor
    mutating func presentTopUpSheet(_ editingItem: Vacation, newlyCreated: Bool) {
        self.editingItem = editingItem
        self.newlyCreated = newlyCreated
        self.showingTopUpView = true
    }
}

struct VacationDaysView: View {
    @State private var config = VacationDaysViewConfig()
    
    @Environment(\.modelContext) private var context
    
    @Query
    private var vacations: [Vacation]
    
    var vacationDays: Double {
        vacations.reduce(0) { $0 - $1.daysUsed }
    }
    
    // TODO: Add a tips view in the future that explains how to use the top up button

    var body: some View {
        // !!!: We need this to force a view update when the editingItem is set.
        // Otherwise we will run into a nil editingItem inside the sheet modifier
        _ = config.editingItem
        return NavigationStack {
            VStack {
                VacationDaysSummaryView(days: vacationDays)
                    .padding(.vertical, 48)
                VacationDaysListView(onEdit: { config.presentEditingSheet($0, newlyCreated: false) })
            }
            .navigationTitle("vacation.navigationTitle")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let newVacation = Vacation(startDate: .now, endDate: .now, daysUsed: 0)
                        context.insert(newVacation)
                        config.presentEditingSheet(newVacation, newlyCreated: true)
                    } label: {
                        Label("vacation.addButton.label", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        let topUpVacation = Vacation(startDate: .now, endDate: .now, daysUsed: 0)
                        context.insert(topUpVacation)
                        config.presentTopUpSheet(topUpVacation, newlyCreated: true)
                    } label: {
                        Text("vacation.topUpButton.label")
                    }
                }
            }
            .sheet(
                isPresented: $config.showingEditingView,
                onDismiss: {
                    if
                        config.newlyCreated,
                        let editingItem = config.editingItem,
                        editingItem.daysUsed == 0
                    {
                        // Delete the newly created vacation again
                        self.context.delete(editingItem)
                    }
                }
            ) {
                if let editingItemBinding = Binding($config.editingItem) {
                    EditVacationDayView(editingItem: editingItemBinding, newlyCreated: config.newlyCreated)
                } else {
                    Text("editVacation.errorEditing")
                }
            }
            .sheet(
                isPresented: $config.showingTopUpView,
                onDismiss: {
                    if
                        config.newlyCreated,
                        let editingItem = config.editingItem,
                        editingItem.daysUsed == 0
                    {
                        // Delete the newly created vacation again
                        self.context.delete(editingItem)
                    }
                }
            ) {
                if let editingItemBinding = Binding($config.editingItem) {
                    TopUpVacationDaysView(editingItem: editingItemBinding, newlyCreated: config.newlyCreated)
                } else {
                    Text("editVacation.errorEditing")
                }
            }
        }
    }
}

#Preview {
    ModelPreview { (_: Vacation) in
        VacationDaysView()
    }
}
