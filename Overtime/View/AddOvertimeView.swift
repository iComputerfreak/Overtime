//
//  AddOvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct AddOvertimeView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @Binding var overtimes: [Int: [Int: [Overtime]]]
    
    @State private var date: Date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        Form {
            Section(header: Text("Überstunden")) {
                DurationPicker(hours: $hours, minutes: $minutes)
            }
            Section(header: Text("Tag")) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
        
        .navigationBarItems(trailing: Button(action: {
            let cal = Calendar.current
            let year = cal.component(.year, from: date)
            let weekOfYear = cal.component(.weekOfYear, from: date)
            
            guard !(overtimes[year]?[weekOfYear]?.contains(where: { $0.date == date }) ?? false) else {
                // We cannot add a overtime for a date, that already has a value!
                AlertHandler.showSimpleAlert(title: "Fehler", message: "Für dieses Datum sind bereits Überstunden eingetragen.")
                return
            }
            
            // Initialize the array, if it is nil
            if overtimes[year] == nil {
                overtimes[year] = [:]
            }
            if overtimes[year]![weekOfYear] == nil {
                overtimes[year]![weekOfYear] = []
            }
            
            // Add the new overtime to the dictionary
            overtimes[year]![weekOfYear]!.append(Overtime(date: date, duration: Duration(hours: hours, minutes: minutes)))
            
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Hinzufügen")
        }))
    }
}

struct AddOvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        AddOvertimeView(overtimes: .constant([:]))
    }
}
