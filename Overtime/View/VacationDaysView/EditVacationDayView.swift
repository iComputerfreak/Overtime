// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftData
import SwiftUI

struct EditVacationDayView: View {
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
    
    @State private var title: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var daysUsed: Double
    
    // To check against already existing dates
    @Query
    private var vacations: [Vacation]
    
    var datesInWrongOrder: Bool {
        startDate > endDate
    }
    
    var vacationAlreadyExists: Bool {
        guard startDate <= endDate else { return false }
        return vacations.contains { vacation in
            (vacation.startDate ..< vacation.endDate).overlaps(with: (startDate ..< endDate)) &&
            vacation.id != editingItem.id
        }
    }
    
    /// Returns whether the current form is valid
    var formValid: Bool {
        !vacationAlreadyExists && !datesInWrongOrder
    }
    
    init(editingItem: Binding<Vacation>, newlyCreated: Bool = false) {
        self._editingItem = editingItem
        self._title = State(wrappedValue: editingItem.wrappedValue.title ?? "")
        let startDate = Calendar.current.startOfDay(for: editingItem.wrappedValue.startDate)
        self._startDate = State(wrappedValue: startDate)
        let endDate = Calendar.current.startOfDay(for: editingItem.wrappedValue.endDate)
        self._endDate = State(wrappedValue: endDate)
        self._daysUsed = State(wrappedValue: editingItem.wrappedValue.daysUsed)
        self.newlyCreated = newlyCreated
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Hours
                Section {
                    TextField("editVacation.textField.title", text: $title)
                    Stepper(value: $daysUsed, in: 0...100, step: 0.5) {
                        HStack {
                            Text("editVacation.stepperLabel.daysUsed")
                            Spacer()
                            Text(verbatim: "\(Self.daysFormatter.string(from: NSNumber(value: daysUsed))!)")
                        }
                    }
                } header: {
                    Text("editVacation.sectionHeader.vacation")
                }
                
                // MARK: Start Date
                Section {
                    DatePicker(selection: $startDate, displayedComponents: .date) {
                        Text("editVacation.startDate.label")
                    }
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text("editVacation.endDate.label")
                    }
                } header: {
                    Text("editVacation.sectionHeader.date")
                } footer: {
                    VStack {
                        if vacationAlreadyExists {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("editVacation.sectionFooter.alreadyExistsMessage")
                            }
                        }

                        if datesInWrongOrder {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("editVacation.sectionFooter.datesInWrongOrderMessage")
                            }
                        }
                    }
                }
                .datePickerStyle(.compact)
            }
            
            .navigationTitle(newlyCreated ? String(localized: "addVacation.navigationTitle") : String(localized: "editVacation.navigationTitle"))
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
                        if newlyCreated {
                            context.delete(editingItem)
                        }
                        self.dismiss()
                    } label: {
                        Text("editVacation.actionLabel.cancel")
                    }
                }
            }
        }
    }
    
    private func commitChanges() {
        editingItem.title = title.isEmpty ? nil : title
        editingItem.startDate = startDate
        editingItem.endDate = endDate
        editingItem.daysUsed = daysUsed
    }
}

#Preview {
    ModelPreview { vacation in
        Text(verbatim: "")
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    EditVacationDayView(editingItem: .constant(vacation))
                }
            }
    }
}
