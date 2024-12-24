// Copyright © 2024 Jonas Frey. All rights reserved.


// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftData
import SwiftUI

struct TopUpVacationDaysView: View {
    // Used to format the days stepper label
    static let daysFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        return f
    }()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Binding private var editingItem: Vacation
    private var newlyCreated: Bool
    @State private var year: Int
    @State private var days: Double
    
    // To check against already existing dates
    @Query
    private var vacations: [Vacation]
    
    /// Returns whether the current form is valid
    var formValid: Bool {
        days > 0
    }
    
    init(editingItem: Binding<Vacation>, newlyCreated: Bool = false) {
        self._editingItem = editingItem
        self._days = State(wrappedValue: abs(editingItem.wrappedValue.daysUsed))
        self._year = State(wrappedValue: editingItem.wrappedValue.startDate[.year])
        self.newlyCreated = newlyCreated
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Hours
                Section {
                    Stepper(value: $days, in: 0...100, step: 0.5) {
                        HStack {
                            Text("editVacationDays.stepperLabel.days")
                            Spacer()
                            Text(verbatim: "\(Self.daysFormatter.string(from: NSNumber(value: days))!)")
                        }
                    }
                    
                    Stepper(value: $year, in: 2000...2100) {
                        HStack {
                            Text("editVacationDays.stepperLabel.year")
                            Spacer()
                            Text(verbatim: "\(year)")
                        }
                    }
                } header: {
                    Text("editVacation.sectionHeader.vacation")
                }
            }
            
            .navigationTitle(newlyCreated ? String(localized: "addVacationDays.navigationTitle") : String(localized: "editVacationDays.navigationTitle"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.commitChanges()
                        self.dismiss()
                    } label: {
                        Text(newlyCreated ? String(localized: "editVacation.actionLabel.add") : String(localized: "editVacation.actionLabel.save"))
                    }
                    .disabled(!formValid)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("editVacation.actionLabel.cancel")
                    }
                }
            }
        }
    }
    
    private func commitChanges() {
        let days = self.days > 0 ? -self.days : 0
        let date = DateComponents(calendar: .current, year: year, month: 1, day: 1).date ?? .now
        editingItem.title = String(localized: "vacation.topUpTitle \(year.description)")
        editingItem.startDate = date
        editingItem.duration = 0
        editingItem.daysUsed = days
    }
}

#Preview {
    ModelPreview { vacation in
        Text(verbatim: "")
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    TopUpVacationDaysView(editingItem: .constant(vacation))
                }
            }
    }
}
