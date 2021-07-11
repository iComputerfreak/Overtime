//
//  OvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct OvertimeView: View {
    
    @State private var values: [Int: [Int: [Overtime]]] = load()
    
    @EnvironmentObject private var userData: UserData
        
    var body: some View {
        NavigationView {
            List {
                // Years (sorted, newest to oldest)
                ForEach(Array(self.values.keys.sorted().reversed()), id: \.self) { (year: Int) in
                        // Weeks of Year (sorted, newest to oldest)
                        ForEach(Array(self.values[year]!.keys.sorted().reversed()), id: \.self) { (weekOfYear: Int) in
                            Section(header: weekHeader(weekOfYear: weekOfYear, year: year)) {
                                // Days (sorted, oldest to newest)
                                ForEach(self.values[year]![weekOfYear]!.sorted(), id: \.date) { (overtime: Overtime) in
                                    OvertimeRow(overtime: overtime)
                                        // Default row height
                                        .frame(height: 22)
                                        .deleteDisabled(false)
                                }
                                .onDelete(perform: { indexSet in
                                    for row in indexSet {
                                        // Get the item that should be deleted
                                        let item = self.values[year]![weekOfYear]!.sorted()[row]
                                        // Get the index in the un-sorted list
                                        guard let index = self.values[year]![weekOfYear]!.firstIndex(of: item) else {
                                            return
                                        }
                                        // Delete the item
                                        self.values[year]![weekOfYear]!.remove(at: index)
                                        
                                        // If the calendar week is now empty, delete it
                                        if self.values[year]![weekOfYear]!.isEmpty {
                                            self.values[year]!.removeValue(forKey: weekOfYear)
                                        }
                                    }
                                })
                                // Last element is the sum
                                weekFooter(weekOfYear: weekOfYear, year: year)
                                    .frame(height: 10)
                            }
                        }
                }
                .listStyle(GroupedListStyle())
            }
            // We need a small last row, so we have to reduce the min row height
            .environment(\.defaultMinListRowHeight, 0)
            .onAppear {
                // Only change is when adding a new overtime
                // After adding a new overtime, the view changes from AddOvertimeView to this view, so didAppear will get called each time
                save()
            }
            .navigationBarItems(trailing: NavigationLink(destination: AddOvertimeView(overtimes: $values), label: {
                Image(systemName: "plus")
            }))
                .navigationBarTitle("Überstunden")
        }
    }
    
    static func load() -> [Int: [Int: [Overtime]]] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return [:]
        }
        do {
            let values = try PropertyListDecoder().decode([Int: [Int: [Overtime]]].self, from: plist)
            return values
        } catch let e {
            print(e)
            return [:]
        }
    }
    
    func save() {
        DispatchQueue.global().async {
            print("Saving...")
            do {
                let plist = try PropertyListEncoder().encode(values)
                UserDefaults.standard.set(plist, forKey: JFUtils.overtimesKey)
            } catch let e {
                print(e)
            }
        }
    }
    
    func weekHeader(weekOfYear: Int, year: Int) -> some View {
        HStack {
            Text("KW \(weekOfYear.description)")
            Spacer()
            Text("\(year.description)")
        }
    }
    
    func weekFooter(weekOfYear: Int, year: Int) -> some View {
        let durations = values[year]![weekOfYear]!.map(\.duration)
        let sum = durations.reduce(.zero, +)
        
        return HStack {
            Text("Summe").bold()
            Spacer()
            Text("\(JFUtils.timeString(sum))").italic()
        }.font(.footnote)
    }
}

struct OvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeView()
    }
}
