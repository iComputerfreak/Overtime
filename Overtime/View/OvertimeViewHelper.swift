//
//  OvertimeHelper.swift
//  Overtime
//
//  Created by Jonas Frey on 07.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

extension OvertimeView {
    
    // MARK: Collapse States
    
    private func formIndex(year: Int, weekOfYear: Int) -> String {
        formIndex(year: year, month: weekOfYear)
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
    
    /// Creates a Binding for the given year and week that proxies the collapse state of the `DisclosureGroup` for the given week
    /// - Parameters:
    ///   - year: The calendar year of the closure group
    ///   - weekOfYear: The week of the given year
    /// - Returns: Whether the `DisclosureGroup` should be currently expanded.
    func weekCollapseStateBinding(year: Int, weekOfYear: Int) -> Binding<Bool> {
        let index = formIndex(year: year, weekOfYear: weekOfYear)
        return Binding {
            return userData.weekCollapseStates.contains(index)
        } set: { newValue in
            if newValue && !userData.weekCollapseStates.contains(index) {
                userData.weekCollapseStates.append(index)
            } else if !newValue {
                userData.weekCollapseStates.removeAll { $0 == index }
            }
        }
    }
    
    // MARK: Weeks
    
    func weekTotal(week: Int, month: Int, year: Int) -> Duration {
        userData.overtimes
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
    
    // MARK: Months
    
    func monthTotal(month: Int, year: Int) -> Duration {
        userData.overtimes
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
        let durations = userData.overtimes.map(\.duration)
        let sum = durations.reduce(.zero, +)
        
        return HStack {
            Text("Summe").bold()
            Spacer()
            Text("\(JFUtils.timeString(sum))").italic()
        }.font(.footnote)
    }
}
