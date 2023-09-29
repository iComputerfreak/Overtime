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
    
    @MainActor
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
            .sorted(by: >)
    }
    
    init() {}
    
    var body: some View {
        // !!!: We need this to force a view update when the editingItem is set.
        // Otherwise we will run into a nil editingItem inside the sheet modifier
        _ = config.editingItem
        return NavigationView {
            VStack {
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
                            EditOvertimeView(editingItem: editingItemBinding)
                        } else {
                            // TODO: Localize
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
        OvertimeView()
            .environmentObject(UserData())
    }
}
