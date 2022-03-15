//
//  ExperimentalView.swift
//  Overtime
//
//  Created by Jonas Frey on 12.12.21.
//  Copyright © 2021 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

struct ExperimentalView: View {
    
    @State private var values: [Int: [Int: [Overtime]]] = load()
    
    @State private var allValues: [Overtime] = []
    
    @EnvironmentObject private var userData: UserData
    
    var totalDuration: Duration {
        // Map all overtime entries to their duration
        let durations = values.flatMap { (year, week: [Int : [Overtime]]) in
            week.flatMap { (weekOfYear, overtimes: [Overtime]) in
                overtimes.map { (overtime: Overtime) in
                    overtime.duration
                }
            }
        }
        // Sum up all durations in the array
        return durations.reduce(.zero, +)
    }
    
    fileprivate init(values: [Int: [Int: [Overtime]]]) {
        self.values = values
        
        var v = [Overtime]()
        for month in values.values {
            for entry in month.values {
                v.append(contentsOf: entry)
            }
        }
        self.allValues = v
    }
    
    @State private var year: Int = {
        Calendar.current.component(.year, from: Date())
    }()
    @State private var month: Int = {
        Calendar.current.component(.month, from: Date())
    }()
    
    private var firstDay: Date {
        var comp = DateComponents()
        comp.year = year
        comp.month = month
        return Calendar.current.date(from: comp)!
    }
    
    // Returns the weekday of the first day this month
    // 0 = Monday to 6 = Sunday
    private var firstWeekday: Int {
        // 1 = Sunday to 7 = Monday
        var firstWeekday = Calendar.current.component(.weekday, from: firstDay)
        firstWeekday -= 2
        if firstWeekday == -1 {
            return 6
        }
        return firstWeekday
    }
    
    init() {}
    
    let spacing: CGFloat = 8
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<4) { week in
                HStack(spacing: spacing) {
                    ForEach(0..<7) { day in
                        let overtime = getOvertime(year: year, month: month, day: day)
                        CalendarDayView(overtime: overtime)
                            .background(Color.gray)
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                }
            }
        }
    }
    
    func getOvertime(year: Int, month: Int, day: Int) -> Overtime {
        return Overtime(date: Date(), duration: .zero)
    }
    
    func deleteOvertime(_ indexSet: IndexSet, year: Int, weekOfYear: Int) {
        for row in indexSet {
            // Get the item that should be deleted
            let item = self.values[year]![weekOfYear]!.sorted()[row]
            // Get the index in the un-sorted list
            guard let index = self.values[year]![weekOfYear]!.firstIndex(of: item) else {
                return
            }
            // Delete the item
            self.values[year]![weekOfYear]!.remove(at: index)
            
            // If the calendar week is now empty, delete it
            if self.values[year]![weekOfYear]!.isEmpty {
                self.values[year]!.removeValue(forKey: weekOfYear)
            }
        }
        self.save()
    }
    
    static func load() -> [Int: [Int: [Overtime]]] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return [:]
        }
        do {
            let values = try PropertyListDecoder().decode([Int: [Int: [Overtime]]].self, from: plist)
            return values
        } catch let e {
            print(e)
            return [:]
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
    
    func weekTotal(weekOfYear: Int, year: Int) -> Duration {
        let week = self.values[year]![weekOfYear]!
        return week.map(\.duration).reduce(.zero, +)
    }
    
    func weekHeader(weekOfYear: Int, year: Int) -> some View {
        HStack {
            Text("KW \(weekOfYear.description), \(year.description)")
            Spacer()
            Text("\(JFUtils.timeString(weekTotal(weekOfYear: weekOfYear, year: year)))")
                .italic()
        }
    }
    
    func weekFooter(weekOfYear: Int, year: Int) -> some View {
        let durations = values[year]![weekOfYear]!.map(\.duration)
        let sum = durations.reduce(.zero, +)
        
        return HStack {
            Text("Summe").bold()
            Spacer()
            Text("\(JFUtils.timeString(sum))").italic()
        }.font(.footnote)
    }
}

struct ExperimentalView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentalView(values: [
            2021: [
                10: [Overtime(date: Date(), duration: Duration(hours: 1))]
            ]
        ])
    }
}
