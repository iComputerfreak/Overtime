//
//  OvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

extension Array where Element == (Int, Int) {
    func contains(_ element: (Int, Int)) -> Bool {
        self.contains { (v1, v2) in
            v1 == element.0 && v2 == element.1
        }
    }
}

struct OvertimeView: View {
    
    @State private var editingItem: Overtime?
    @State private var showingEditingView: Bool = false
    
    @EnvironmentObject var userData: UserData
    @Environment(\.scenePhase) var scenePhase
    
    fileprivate init(values: [Overtime]) {
        userData.overtimes = userData.overtimes
    }
    
    init() {}
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                // Years (sorted, newest to oldest)
                ForEach(Array(userData.overtimeYears.sorted().reversed()), id: \.self) { (year: Int) in
                    // Month of Year (sorted, newest to oldest)
                    ForEach(userData.overtimeMonths(year: year).sorted().reversed(), id: \.self) { (month: Int) in
                        DisclosureGroup(isExpanded: monthCollapseStateBinding(year: year, month: month), content: {
                            // Weeks (sorted, oldest to newest)
                            ForEach(userData.overtimeWeeks(year: year, month: month).sorted().reversed(), id: \.self) { (week: Int) in
                                //Section(header: weekHeader(week: week, month: month, year: year)) {
                                DisclosureGroup(isExpanded: weekCollapseStateBinding(year: year, weekOfYear: week), content: {
                                    // Days (sorted, oldest to newest)
                                    ForEach(userData.overtimes(for: year, month: month, week: week).sorted(), id: \.date) { (overtime: Overtime) in
                                        OvertimeRow(overtime: overtime)
                                        // Default row height
                                            .frame(height: 22)
                                            .deleteDisabled(false)
                                            .contextMenu {
                                                Button("Bearbeiten") {
                                                    if let index = userData.overtimes.firstIndex(of: overtime) {
                                                        self.editingItem = userData.overtimes[index]
                                                        self.showingEditingView = true
                                                    }
                                                }
                                            }
                                    }
                                    .onDelete(perform: { indexSet in self.deleteOvertime(indexSet, year: year, month: month, week: week) })
                                }, label: {
                                    weekHeader(week: week, month: month, year: year)
                                })
                            }
                        }, label: {
                            monthHeader(month: month, year: year)
                        })
                    }
                }
                // Sum
                HStack {
                    Text("Gesamt:")
                        .bold()
                    Spacer()
                    Text(JFUtils.timeString(userData.totalOvertimeDuration))
                        .bold()
                }
            }
            // We need a small last row, so we have to reduce the min row height
            .environment(\.defaultMinListRowHeight, 0)
            .navigationBarItems(trailing: NavigationLink(destination: AddOvertimeView(overtimes: $userData.overtimes), label: {
                Image(systemName: "plus")
            }))
            .navigationBarTitle("Überstunden")
            // Handles showing the editing view when the user edits an item via the context menu
            NavigationLink(
                destination: AddOvertimeView(overtimes: $userData.overtimes, overtime: self.editingItem),
                isActive: $showingEditingView,
                label: { EmptyView() })
            }
        }
    }
    
    func deleteOvertime(_ indexSet: IndexSet, year: Int, month: Int, week: Int) {
        for row in indexSet {
            // Get the item that should be deleted
            let item = userData.overtimes(for: year, month: month, week: week).sorted()[row]
            // Get the index in the un-sorted list
            guard let index = userData.overtimes.firstIndex(of: item) else {
                return
            }
            // Delete the item
            userData.overtimes.remove(at: index)
        }
    }
}

struct OvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeView(values: [
            Overtime(date: Date(), duration: Duration(hours: 1))
        ])
    }
}
