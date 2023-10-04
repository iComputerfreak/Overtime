//
//  MonthSection.swift
//  Overtime
//
//  Created by Jonas Frey on 04.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

/// Represents a list section that displays the given content.
///
/// The style/type of the section depends on the ``UserData/monthSectionStyle`` value.
struct MonthSection<Content: View>: View {
    @Environment(\.monthSectionStyle) private var monthSectionStyle
    @EnvironmentObject private var userData: UserData
    
    let year: Int
    let month: Int
    let content: () -> Content
    
    @Query
    var overtimes: [Overtime]
    
    var totalDuration: TimeInterval {
        overtimes
            .map(\.duration)
            .reduce(0, +)
    }
    
    init(year: Int, month: Int, @ViewBuilder content: @escaping () -> Content) {
        self.year = year
        self.month = month
        self.content = content
        self._overtimes = Query(
            filter: Overtime.predicate(for: year, month: month),
            sort: \Overtime.date,
            order: .forward
        )
    }
    
    var body: some View {
        switch monthSectionStyle {
        case .monthDisclosureGroups:
            DisclosureGroup(isExpanded: monthCollapseStateBinding(year: year, month: month)) {
                self.content()
            } label: {
                // Month header
                HStack {
                    Text(verbatim: "\(Calendar.current.monthSymbols[month - 1]) \(year.description)")
                        .bold()
                    Spacer()
                    Text(verbatim: "\(JFUtils.timeString(totalDuration))")
                }
            }
        case .monthSections:
            Section {
                self.content()
            } header: {
                HStack {
                    Text(verbatim: "\(Calendar.current.monthSymbols[month - 1]) \(year.description)")
                    Spacer()
                    Text(JFUtils.timeString(totalDuration))
                }
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
        let index = formIndex(year: year, month: month)
        return Binding {
            return userData.monthCollapseStates.contains(index)
        } set: { newValue in
            if newValue && !userData.monthCollapseStates.contains(index) {
                userData.monthCollapseStates.append(index)
            } else if !newValue {
                userData.monthCollapseStates.removeAll(where: { $0 == index })
            }
        }
    }
}

#Preview {
    List {
        MonthSection(year: 2023, month: 3) {
            Text("Test")
        }
    }
    .environmentObject(UserData())
}
