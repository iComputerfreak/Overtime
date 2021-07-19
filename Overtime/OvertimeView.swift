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
    
    var totalDuration: Duration {
        // Map all overtime entries to their duration
        let durations = values.flatMap { (year, week: [Int : [Overtime]]) in
            week.flatMap { (weekOfYear, overtimes: [Overtime]) in
                overtimes.map { (overtime: Overtime) in
                    overtime.duration
                }
            }
        }
        // Sum up all durations in the array
        return durations.reduce(.zero, +)
    }
    
    fileprivate init(values: [Int: [Int: [Overtime]]]) {
        self.values = values
    }
    
    init() {}
        
    var body: some View {
        NavigationView {
            List {
                // Sum
                HStack {
                    Text("Gesamt:")
                        .bold()
                    Spacer()
                    Text(JFUtils.timeString(totalDuration))
                        .bold()
                }
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
                                .onDelete(perform: { indexSet in self.deleteOvertime(indexSet, year: year, weekOfYear: weekOfYear) })
                                // Last element is the sum
                                weekFooter(weekOfYear: weekOfYear, year: year)
                                    .frame(height: 10)
                            }
                        }
                }
            }
            .listStyle(SidebarListStyle())
            // We need a small last row, so we have to reduce the min row height
            .environment(\.defaultMinListRowHeight, 0)
            .onAppear {
                // If the overtimes values were invalidated (e.g., by deleting them in the settings), load them from disk
                if JFUtils.overtimesInvalidated {
                    self.values = Self.load()
                    JFUtils.overtimesInvalidated = false
                } else {
                    // Only change is when adding a new overtime
                    // After adding a new overtime, the view changes from AddOvertimeView to this view, so didAppear will get called each time
                    save()
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: AddOvertimeView(overtimes: $values), label: {
                Image(systemName: "plus")
            }))
                .navigationBarTitle("Überstunden")
        }
    }
    
    func deleteOvertime(_ indexSet: IndexSet, year: Int, weekOfYear: Int) {
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
        self.save()
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
    
    func weekTotal(weekOfYear: Int, year: Int) -> Duration {
        let week = self.values[year]![weekOfYear]!
        return week.map(\.duration).reduce(.zero, +)
    }
    
    func weekHeader(weekOfYear: Int, year: Int) -> some View {
        HStack {
            Text("KW \(weekOfYear.description), \(year.description)")
            Spacer()
            Text("\(JFUtils.timeString(weekTotal(weekOfYear: weekOfYear, year: year)))")
                .italic()
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
        OvertimeView(values: [
            2021: [
                10: [Overtime(date: Date(), duration: Duration(hours: 1))]
            ]
        ])
    }
}
