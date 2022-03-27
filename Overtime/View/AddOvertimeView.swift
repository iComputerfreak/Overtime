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
    @State private var hours: Double = 0.0
    
    var hoursFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }
    
    var body: some View {
        Form {
            Section(header: Text("Überstunden")) {
                Stepper(value: $hours, in: -24...24, step: 0.25, label: {
                    HStack {
                        Text("Stunden")
                        Spacer()
                        Text("\(hoursFormatter.string(from: NSNumber(value: hours))!)")
                    }
                })
            }
            Section(header: Text("Tag")) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
        
        .navigationBarItems(trailing: Button(action: {
            guard !overtimes.contains(where: {
                $0.date[.day] == date[.day] && $0.date[.month] == date[.month] && $0.date[.year] == date[.year]
            }) else {
                // We cannot add a overtime for a date, that already has a value!
                AlertHandler.showSimpleAlert(title: "Fehler",
                                             message: "Für dieses Datum sind bereits Überstunden eingetragen.")
                return
            }
                        
            // Add the new overtime to the dictionary
            let hours = Int(self.hours)
            // We first cut off all full hours, so we only get the remaining minutes
            // Then we multiply that value with 60 and round to full integer digits to get the minutes
            let minutes = Int((self.hours.truncatingRemainder(dividingBy: 1) * 60).rounded())
            overtimes.append(Overtime(date: date, duration: Duration(hours: hours, minutes: minutes)))
            
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
