//
//  OvertimeMonthSection.swift
//  Overtime
//
//  Created by Jonas Frey on 29.09.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

struct OvertimeMonthSection: View {
    @Environment(\.modelContext) private var context
    
    let year: Int
    let month: Int
    @Binding var config: OvertimeViewConfig
    
    @Query
    var overtimes: [Overtime]
    
    init(year: Int, month: Int, config: Binding<OvertimeViewConfig>) {
        self.year = year
        self.month = month
        self._config = config
        self._overtimes = Query(
            filter: Overtime.predicate(for: year, month: month),
            sort: \Overtime.date,
            order: .forward
        )
    }
    
    var body: some View {
        MonthSection(year: year, month: month) {
            ForEach(overtimes) { (overtime: Overtime) in
                OvertimeRow(overtime: overtime)
                // Default row height
                    .frame(height: 22)
                    .deleteDisabled(false)
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            context.delete(overtime)
                        } label: {
                            Label("actionLabel.delete", systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            config.presentEditingSheet(overtime)
                        } label: {
                            Label("actionLabel.edit", systemImage: "pencil")
                        }
                    }
            }
        }
    }
}

#Preview {
    OvertimeMonthSection(year: 2023, month: 09, config: .constant(.init()))
}
