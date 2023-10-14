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
    @EnvironmentObject private var userData: UserData
    
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
            ForEach(overtimes) { overtime in
                // TODO: For some reason extracting this in a view does not work. Even when using @ObservedObject
                // TODO: Debug
//                OvertimeRow(overtime: overtime)
                HStack {
                    // Date
                    Text(userData.dateFormatter.string(from: overtime.date))
                    Spacer()
                    // Time
                    Text(JFUtils.timeString(overtime.duration))
                        .foregroundStyle(color(for: overtime.duration))
                }
                .deleteDisabled(false)
                .swipeActions(allowsFullSwipe: true) {
                    Button {
                        context.delete(overtime)
                    } label: {
                        Label("actionLabel.delete", systemImage: "trash")
                    }
                    .tint(.red)
                    Button {
                        config.presentEditingSheet(overtime, newlyCreated: false)
                    } label: {
                        Label("actionLabel.edit", systemImage: "pencil")
                    }
                }
            }
        }
    }
    
    func color(for duration: TimeInterval) -> Color {
        if duration < 0 {
            return .red
        } else if duration > 0 {
            return .green
        } else {
            return .primary
        }
    }
}

#Preview {
    OvertimeMonthSection(year: 2023, month: 09, config: .constant(.init()))
}
