//
//  Duration.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct Duration: AdditiveArithmetic, Codable {
    
    let seconds: Int
    
    var minutes: Int {
        return seconds / 60
    }
    
    var hours: Int {
        return minutes / 60
    }
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    init(minutes: Int) {
        self.init(seconds: minutes * 60)
    }
    
    init(hours: Int) {
        self.init(seconds: hours * 3600)
    }
    
    init(hours: Int, minutes: Int) {
        self.init(seconds: hours * 3600 + minutes * 60)
    }
    
    
    static let zero = Duration(seconds: 0)
    
    static func + (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds + rhs.seconds)
    }
    
    static func - (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.seconds - rhs.seconds)
    }
    
}
