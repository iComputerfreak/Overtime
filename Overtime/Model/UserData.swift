//
//  UserData.swift
//  Overtime
//
//  Created by Jonas Frey on 01.09.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

class UserData: ObservableObject, Codable {
    
    private static let dateFormatKey = "dateFormat"
    var dateFormat: String = UserDefaults.standard.string(forKey: dateFormatKey) ?? "E, d. MMM" { // Sun, 5. Jan
        willSet {
            // When changing this value, notify all views
            objectWillChange.send()
        }
        didSet {
            // After changing the date format, save it
            UserDefaults.standard.set(dateFormat, forKey: UserData.dateFormatKey)
        }
    }
    
    var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = dateFormat
        return f
    }
    
}
