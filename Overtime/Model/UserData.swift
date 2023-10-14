//
//  UserData.swift
//  Overtime
//
//  Created by Jonas Frey on 01.09.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation
import JFUtils

class UserData: ObservableObject {
    
    private static let dateFormatKey = "dateFormat"
    private static let monthSectionStyleKey = "monthSectionStyle"
    private static let monthCollapseStatesKey = "monthCollapseStates"
    private static let weekCollapseStatesKey = "weekCollapseStates"
    
    @Published var dateFormat: String {
        didSet {
            // After changing the date format, save it immediately and update the date formatter
            UserDefaults.standard.set(dateFormat, forKey: Self.dateFormatKey)
            self.dateFormatter.dateFormat = self.dateFormat
        }
    }
    
    @Published var monthSectionStyle: MonthSectionStyle {
        didSet {
            UserDefaults.standard.set(monthSectionStyle.rawValue, forKey: Self.monthSectionStyleKey)
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
    
    init() {
        // Load data from UserDefaults (default: 'Sun, 5. Jan')
        let dateFormat = UserDefaults.standard.string(forKey: Self.dateFormatKey) ?? "E, d. MMM"
        self.dateFormat = dateFormat
        self.monthSectionStyle = (UserDefaults.standard.string(forKey: Self.monthSectionStyleKey)
            .map(MonthSectionStyle.init(rawValue:)) ?? nil) ?? .defaultValue
        self.monthCollapseStates = UserDefaults.standard.array(forKey: Self.monthCollapseStatesKey) as? [String] ?? []
        self.weekCollapseStates = UserDefaults.standard.array(forKey: Self.weekCollapseStatesKey) as? [String] ?? []
    }
    
    func save() {
        // Save the collapse states
        UserDefaults.standard.set(dateFormat, forKey: Self.dateFormatKey)
        UserDefaults.standard.set(monthSectionStyle, forKey: Self.monthSectionStyleKey)
        UserDefaults.standard.set(monthCollapseStates, forKey: Self.monthCollapseStatesKey)
        UserDefaults.standard.set(weekCollapseStates, forKey: Self.weekCollapseStatesKey)
    }
    
    /// Resets the content stored in this object
    func reset() {
        self.monthCollapseStates = []
        self.weekCollapseStates = []
    }
}
