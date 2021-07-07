//
//  Overtime.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct Overtime: Comparable, Codable {
    let date: Date
    let duration: Duration
    
    static func < (lhs: Overtime, rhs: Overtime) -> Bool {
        return lhs.date < rhs.date
    }
}
