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
    @Binding var overtimes: [Overtime]
    
    @State private var date: Date = Date()
    @State private var negative: Bool = false
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        Form {
            Section(header: Text("Überstunden")) {
                Toggle("Negativ", isOn: $negative)
                Stepper(value: $hours, in: 0...24, label: {
                    HStack {
                        Text("Stunden")
                        Spacer()
                        Text("\(hours)")
                    }
                })
                Stepper(value: $minutes, in: 0...45, step: 15, label: {
                    HStack {
                        Text("Minuten")
                        Spacer()
                        Text("\(minutes)")
                    }
                })
                //DurationPicker(hours: $hours, minutes: $minutes)
            }
            Section(header: Text("Tag")) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
        
        .navigationBarItems(trailing: Button(action: {
            guard !overtimes.contains(where: { $0.date == date }) else {
                // We cannot add a overtime for a date, that already has a value!
                AlertHandler.showSimpleAlert(title: "Fehler", message: "Für dieses Datum sind bereits Überstunden eingetragen.")
                return
            }
                        
            // Add the new overtime to the dictionary
            overtimes.append(Overtime(date: date, duration: Duration(hours: hours, minutes: minutes, negative: negative)))
            
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Hinzufügen")
        }))
    }
}

struct AddOvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        AddOvertimeView(overtimes: .constant([]))
    }
}
