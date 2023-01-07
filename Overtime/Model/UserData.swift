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
    
    // TODO: Move Overtimes in here
    
    @Published var dateFormat: String {
        didSet {
            // After changing the date format, save it immediately
            UserDefaults.standard.set(dateFormat, forKey: UserData.dateFormatKey)
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
        self.dateFormat = UserDefaults.standard.string(forKey: Self.dateFormatKey) ?? "E, d. MMM"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateFormat = try container.decode(String.self, forKey: .dateFormat)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateFormat, forKey: .dateFormat)
    }
    
    enum CodingKeys: String, CodingKey {
        case dateFormat
    }
}
