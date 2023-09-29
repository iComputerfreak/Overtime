//
//  AddOvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import JFUtils
import SwiftData
import SwiftUI

struct AddOvertimeView: View {
    // Used to format the duration stepper label
    static let hoursFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var editingItem: Overtime
    @State private var date: Date
    @State private var hours: Double
    
    // To check against already existing dates
    @Query
    private var overtimes: [Overtime]
    
    var dateAlreadyExists: Bool {
        overtimes.contains { overtime in
            let date = overtime.date
            return date[.day] == self.date[.day] &&
            date[.month] == self.date[.month] &&
            date[.year] == self.date[.year] &&
            overtime.id != editingItem.id
        }
    }
    
    /// Returns whether the current form is valid
    var formValid: Bool {
        // The form is valid, if the selected date does not already exist in the list of overtimes
        !dateAlreadyExists
    }
    
    init(editingItem: Binding<Overtime>) {
        self._editingItem = editingItem
        self._date = State(wrappedValue: editingItem.wrappedValue.date)
        self._hours = State(wrappedValue: editingItem.wrappedValue.duration / .hour)
    }
    
    var body: some View {
        Form {
            Section(header: Text("newOvertime.sectionHeader.overtime")) {
                Stepper(value: $hours, in: -24...24, step: 0.25, label: {
                    HStack {
                        Text("newOvertime.stepperLabel.hours")
                        Spacer()
                        Text("\(Self.hoursFormatter.string(from: NSNumber(value: hours))!)")
                    }
                })
            }
            Section(header: Text("newOvertime.sectionHeader.date")) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                if dateAlreadyExists {
                    // TODO: Localize and make nicer
                    Text("Date already exists.")
                }
            }
        }
        
        .navigationTitle("newOvertime.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.commitChanges()
                    self.dismiss()
                } label: {
                    Text("newOvertime.actionLabel.add")
                }
                .disabled(!formValid)
            }
        }
    }
    
    private func commitChanges() {
        editingItem.date = date
        editingItem.duration = hours * .hour
    }
}

struct AddOvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddOvertimeView(editingItem: .constant(.init(date: .now, duration: 2.5 * .hour)))
        }
    }
}
