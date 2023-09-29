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
    
    var totalDuration: TimeInterval {
        overtimes
            .map(\.duration)
            .reduce(0, +)
    }
    
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
        DisclosureGroup(isExpanded: monthCollapseStateBinding(year: year, month: month)) {
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
        } label: {
            // Month header
            HStack {
                Text(verbatim: "\(Calendar.current.monthSymbols[month - 1]) \(year.description)")
                    .bold()
                Spacer()
                Text(verbatim: "\(JFUtils.timeString(totalDuration))")
            }
        }
    }
    
    // The index to use for looking up the collapse state
    private func formIndex(year: Int, month: Int) -> String {
        return "\(year)_\(month)"
    }
    
    /// Creates a Binding for the given year and month that proxies the collapse state of the `DisclosureGroup` for the given month
    /// - Parameters:
    ///   - year: The calendar year of the closure group
    ///   - month: The month of the given year
    /// - Returns: Whether the `DisclosureGroup` should be currently expanded.
    func monthCollapseStateBinding(year: Int, month: Int) -> Binding<Bool> {
        return .constant(true)
//        let index = formIndex(year: year, month: month)
//        return Binding {
//            return userData.monthCollapseStates.contains(index)
//        } set: { newValue in
//            if newValue && !userData.monthCollapseStates.contains(index) {
//                userData.monthCollapseStates.append(index)
//            } else if !newValue {
//                userData.monthCollapseStates.removeAll(where: { $0 == index })
//            }
//        }
    }
}

#Preview {
    OvertimeMonthSection(year: 2023, month: 09, config: .constant(.init()))
}
