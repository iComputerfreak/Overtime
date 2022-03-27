//
//  OvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct OvertimeView: View {
    
    @State private var values: [Overtime] = load()
    
    @EnvironmentObject private var userData: UserData
    @State private var editingItem: Overtime?
    @State private var showingEditingView: Bool = false
    
    var totalDuration: Duration {
        values.map(\.duration).reduce(.zero, +)
    }
    
    fileprivate init(values: [Overtime]) {
        self.values = values
    }
    
    private var years: [Int] {
        Array(Set(self.values.map({ $0.date[.year] })))
    }
    
    private func months(year: Int) -> [Int] {
        Array(Set(self.values.filter({ $0.date[.year] == year }).map({ $0.date[.month] })))
    }
    
    private func weeks(year: Int, month: Int) -> [Int] {
        Array(Set(
            self.values
                .filter({ $0.date[.year] == year && $0.date[.month] == month })
                .map({ $0.date[.weekOfYear] })
        ))
    }
    
    private func overtimes(year: Int, month: Int, week: Int) -> [Overtime] {
        self.values.filter({ $0.date[.year] == year && $0.date[.month] == month && $0.date[.weekOfYear] == week })
    }
    
    init() {}
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                // Years (sorted, newest to oldest)
                ForEach(Array(years.sorted().reversed()), id: \.self) { (year: Int) in
                    // Month of Year (sorted, newest to oldest)
                    ForEach(Array(months(year: year).sorted().reversed()), id: \.self) { (month: Int) in
                        Section(header: monthHeader(month: month, year: year)) {
                            // Weeks (sorted, oldest to newest)
                            ForEach(weeks(year: year, month: month).sorted().reversed(), id: \.self) { (week: Int) in
                                Section(header: weekHeader(week: week, month: month, year: year)) {
                                    // Days (sorted, oldest to newest)
                                    ForEach(overtimes(year: year, month: month, week: week).sorted(), id: \.date) { (overtime: Overtime) in
                                        OvertimeRow(overtime: overtime)
                                        // Default row height
                                            .frame(height: 22)
                                            .deleteDisabled(false)
                                            .contextMenu {
                                                Button("Bearbeiten") {
                                                    let index = values.firstIndex(of: overtime)!
                                                    self.editingItem = self.values[index]
                                                    self.showingEditingView = true
                                                }
                                            }
                                    }
                                    .onDelete(perform: { indexSet in self.deleteOvertime(indexSet, year: year, month: month, week: week) })
                                    // Last element is the sum
//                                    monthFooter(month: month, year: year)
//                                        .frame(height: 10)
                                }
                            }
                        }
                    }
                }
                // Sum
                HStack {
                    Text("Gesamt:")
                        .bold()
                    Spacer()
                    Text(JFUtils.timeString(totalDuration))
                        .bold()
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
            // Handles showing the editing view when the user edits an item via the context menu
            NavigationLink(
                destination: AddOvertimeView(overtimes: $values, overtime: self.editingItem),
                isActive: $showingEditingView,
                label: { EmptyView() })
            }
        }
    }
    
    func deleteOvertime(_ indexSet: IndexSet, year: Int, month: Int, week: Int) {
        for row in indexSet {
            // Get the item that should be deleted
            let item = overtimes(year: year, month: month, week: week).sorted()[row]
            // Get the index in the un-sorted list
            guard let index = self.values.firstIndex(of: item) else {
                return
            }
            // Delete the item
            self.values.remove(at: index)
        }
        self.save()
    }
    
    static func load() -> [Overtime] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return []
        }
        do {
            let values = try PropertyListDecoder().decode([Overtime].self, from: plist)
            return values
        } catch let e {
            print(e)
            return []
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
    
    func weekTotal(week: Int, month: Int, year: Int) -> Duration {
        self.values
            .filter({ $0.date[.year] == year && $0.date[.month] == month && $0.date[.weekOfYear] == week })
            .map(\.duration)
            .reduce(.zero, +)
    }
    
    func weekHeader(week: Int, month: Int, year: Int) -> some View {
        HStack {
            Text("KW \(week)")
            Spacer()
            Text("\(JFUtils.timeString(weekTotal(week: week, month: month, year: year)))")
                .italic()
        }
    }
    
    func monthTotal(month: Int, year: Int) -> Duration {
        self.values
            .filter({ $0.date[.year] == year && $0.date[.month] == month })
            .map(\.duration)
            .reduce(.zero, +)
    }
    
    func monthHeader(month: Int, year: Int) -> some View {
        HStack {
            Text("\(Calendar.current.monthSymbols[month - 1]) \(year.description)")
            Spacer()
            Text("\(JFUtils.timeString(monthTotal(month: month, year: year)))")
        }
    }
    
    func monthFooter(month: Int, year: Int) -> some View {
        let durations = values.map(\.duration)
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
            Overtime(date: Date(), duration: Duration(hours: 1))
        ])
    }
}
