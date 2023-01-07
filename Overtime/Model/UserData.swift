//
//  UserData.swift
//  Overtime
//
//  Created by Jonas Frey on 01.09.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation
import JFUtils

class UserData: ObservableObject, Codable {
    
    private static let dateFormatKey = "dateFormat"
    private static let monthCollapseStatesKey = "monthCollapseStates"
    private static let weekCollapseStatesKey = "weekCollapseStates"
        
    @Published var dateFormat: String {
        didSet {
            // After changing the date format, save it immediately and update the date formatter
            UserDefaults.standard.set(dateFormat, forKey: Self.dateFormatKey)
            self.dateFormatter.dateFormat = self.dateFormat
        }
    }
    
    @Published var overtimes: [Overtime] {
        didSet {
            print("Overtimes changed!")
            self.save()
        }
    }
    
    @Published var monthCollapseStates: [String] {
        didSet {
            UserDefaults.standard.set(monthCollapseStates, forKey: Self.monthCollapseStatesKey)
        }
    }
    
    @Published var weekCollapseStates: [String] {
        didSet {
            UserDefaults.standard.set(weekCollapseStates, forKey: Self.weekCollapseStatesKey)
        }
    }
    
    lazy private(set) var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = dateFormat
        return f
    }()
    
    // MARK: Convenience properties
    
    var totalOvertimeDuration: Duration {
        overtimes.map(\.duration).reduce(.zero, +)
    }
    
    var overtimeYears: [Int] {
        Array(Set(overtimes.map({ $0.date[.year] })))
    }
    
    func overtimeMonths(year: Int) -> [Int] {
        Array(Set(overtimes.filter({ $0.date[.year] == year }).map({ $0.date[.month] })))
    }
    
    func overtimeWeeks(year: Int, month: Int) -> [Int] {
        Array(Set(
            overtimes
                .filter({ $0.date[.year] == year && $0.date[.month] == month })
                .map({ $0.date[.weekOfYear] })
        ))
    }
    
    func overtimes(for year: Int, month: Int, week: Int) -> [Overtime] {
        overtimes.filter({ $0.date[.year] == year && $0.date[.month] == month && $0.date[.weekOfYear] == week })
    }
    
    init() {
        // Load data from UserDefaults (default: 'Sun, 5. Jan')
        self.dateFormat = UserDefaults.standard.string(forKey: Self.dateFormatKey) ?? "E, d. MMM"
        self.overtimes = Self.loadOvertimes()
        self.monthCollapseStates = UserDefaults.standard.array(forKey: Self.monthCollapseStatesKey) as? [String] ?? []
        self.weekCollapseStates = UserDefaults.standard.array(forKey: Self.weekCollapseStatesKey) as? [String] ?? []
    }
    
    static func loadOvertimes() -> [Overtime] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            // No data to read or data is corrupted
            return []
        }
        do {
            // Deocde the list of overtimes from the plist data
            return try PropertyListDecoder().decode([Overtime].self, from: plist)
        } catch let e {
            // Error decoding the overtimes. Maybe the app updated?
            print("Error loading overtimes.")
            print(e)
            AlertHandler.showSimpleAlert(
                title: "Fehler bei Laden der Daten",
                message: "Fehler beim Laden der Daten. Um Datenverlust zu verhindern, wird die App nun beendet."
            )
            exit(0)
        }
    }
    
    func save() {
        do {
            // Encode the overtimes and save them to UserDefaults
            let plist = try PropertyListEncoder().encode(self.overtimes)
            UserDefaults.standard.set(plist, forKey: JFUtils.overtimesKey)
            // Save the collapse states
            UserDefaults.standard.set(monthCollapseStates, forKey: Self.monthCollapseStatesKey)
            UserDefaults.standard.set(weekCollapseStates, forKey: Self.weekCollapseStatesKey)
        } catch {
            print("Error encoding overtimes.")
            print(error)
        }
    }
    
    // MARK: - Codable Conformance
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateFormat = try container.decode(String.self, forKey: .dateFormat)
        self.overtimes = try container.decode([Overtime].self, forKey: .overtimes)
        self.monthCollapseStates = try container.decode([String].self, forKey: .monthCollapseStates)
        self.weekCollapseStates = try container.decode([String].self, forKey: .weekCollapseStates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateFormat, forKey: .dateFormat)
        try container.encode(overtimes, forKey: .overtimes)
        try container.encode(monthCollapseStates, forKey: .monthCollapseStates)
        try container.encode(weekCollapseStates, forKey: .weekCollapseStates)
    }
    
    enum CodingKeys: String, CodingKey {
        case dateFormat
        case overtimes
        case monthCollapseStates
        case weekCollapseStates
    }
}
