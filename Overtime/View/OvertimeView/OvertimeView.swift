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
    var newlyCreated: Bool = false
    var showingEditingView: Bool = false
    
    @MainActor
    mutating func presentEditingSheet(_ editingItem: Overtime, newlyCreated: Bool) {
        self.editingItem = editingItem
        self.newlyCreated = newlyCreated
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
            .sorted(by: >)
    }
    
    init() {}
    
    var body: some View {
        // !!!: We need this to force a view update when the editingItem is set.
        // Otherwise we will run into a nil editingItem inside the sheet modifier
        _ = config.editingItem
        return NavigationView {
            VStack(spacing: 0) {
                List {
                    // MARK: Years
                    ForEach(years, id: \.self) { (year: Int) in
                        OvertimeYearSection(year: year, config: $config)
                    }
                }
                .toolbar {
                    Button {
                        let overtime = Overtime(date: .now, duration: 0)
                        context.insert(overtime)
                        config.presentEditingSheet(overtime, newlyCreated: true)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                Divider()
                SumFooter()
                    .padding(.vertical, 8)
                .navigationTitle("overtimes.title")
                .sheet(isPresented: $config.showingEditingView) {
                    NavigationStack {
                        if let editingItemBinding = Binding($config.editingItem) {
                            EditOvertimeView(editingItem: editingItemBinding, newlyCreated: config.newlyCreated)
                        } else {
                            Text("newOvertime.errorEditing")
                        }
                    }
                }
            }
        }
    }
}

struct OvertimeView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            OvertimeView()
                .previewEnvironment()
        }
    }
}
