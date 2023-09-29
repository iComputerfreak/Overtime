//
//  OvertimeView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

struct OvertimeViewConfig {
    var editingItem: Overtime?
    var showingEditingView: Bool = false
    
    mutating func presentEditingSheet(_ editingItem: Overtime) {
        self.editingItem = editingItem
        self.showingEditingView = true
    }
}

struct OvertimeView: View {
    
    @State private var config = OvertimeViewConfig()
    
    @Query(sort: \Overtime.date, order: .reverse) var overtimes: [Overtime]
    
    @EnvironmentObject var userData: UserData
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var context
    
    var years: [Int] {
        overtimes
            .map { $0.date[.year] }
            .removingDuplicates()
    }
    
    init() {}
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // MARK: Years
                    ForEach(years, id: \.self) { (year: Int) in
                        OvertimeYearSection(year: year, config: $config)
                    }
                    
                    
//                    // MARK: Years (sorted, newest to oldest)
//                    ForEach(Array(userData.overtimeYears.sorted().reversed()), id: \.self) { (year: Int) in
//                        // Month of Year (sorted, newest to oldest)
//                        ForEach(userData.overtimeMonths(year: year).sorted().reversed(), id: \.self) { (month: Int) in
//                            DisclosureGroup(isExpanded: monthCollapseStateBinding(year: year, month: month), content: {
//                                // Weeks (sorted, oldest to newest)
//                                ForEach(userData.overtimeWeeks(year: year, month: month).sorted().reversed(), id: \.self) { (week: Int) in
//                                    //Section(header: weekHeader(week: week, month: month, year: year)) {
//                                    DisclosureGroup(isExpanded: weekCollapseStateBinding(year: year, weekOfYear: week), content: {
//                                        // Days (sorted, oldest to newest)
//                                        ForEach(userData.overtimes(for: year, month: month, week: week).sorted(), id: \.date) { (overtime: Overtime) in
//                                            OvertimeRow(overtime: overtime)
//                                            // Default row height
//                                                .frame(height: 22)
//                                                .deleteDisabled(false)
//                                                .swipeActions(allowsFullSwipe: true) {
//                                                    Button {
//                                                        if let index = userData.overtimes.firstIndex(of: overtime) {
//                                                            userData.overtimes.remove(at: index)
//                                                        }
//                                                    } label: {
//                                                        Label("actionLabel.delete", systemImage: "trash")
//                                                    }
//                                                    .tint(.red)
//                                                    Button {
//                                                        if let index = userData.overtimes.firstIndex(of: overtime) {
//                                                            self.editingItem = userData.overtimes[index]
//                                                            self.showingEditingView = true
//                                                        }
//                                                    } label: {
//                                                        Label("actionLabel.edit", systemImage: "pencil")
//                                                    }
//                                                }
//                                        }
//                                    }, label: {
//                                        weekHeader(week: week, month: month, year: year)
//                                    })
//                                }
//                            }, label: {
//                                monthHeader(month: month, year: year)
//                            })
//                        }
//                    }
                }
                // We need a small last row, so we have to reduce the min row height
                .environment(\.defaultMinListRowHeight, 0)
                .toolbar {
                    Button {
                        let overtime = Overtime(date: .now, duration: 0)
                        context.insert(overtime)
                        config.presentEditingSheet(overtime)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                // Sum
                SumFooter()
                .navigationTitle("overtimes.title")
                .sheet(isPresented: $config.showingEditingView) {
                    NavigationStack {
                        if let editingItemBinding = Binding($config.editingItem) {
                            AddOvertimeView(editingItem: editingItemBinding)
                        } else {
                            // TODO: Localize
                            Text("Error")
                        }
                    }
                }
            }
        }
    }
}

struct OvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeView()
            .environmentObject(UserData.preview)
    }
}
