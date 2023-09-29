//
//  Duration.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct Duration: AdditiveArithmetic, Codable, Hashable {
    
    let negative: Bool
    let seconds: Int
    
    var signedSeconds: Int { negative ? -seconds : seconds }
    
    var minutes: Int {
        return seconds / 60
    }
    
    var hours: Int {
        return minutes / 60
    }
    
    var components: (hours: Int, minutes: Int, seconds: Int, isNegative: Bool) {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = minutes % 60
        return (hours, minutes, seconds, negative)
    }
    
    init(seconds: Int) {
        self.negative = seconds < 0
        self.seconds = abs(seconds)
    }
    
    init(seconds: Int, negative: Bool) {
        self.init(seconds: negative ? -seconds : seconds)
    }
    
    init(minutes: Int, negative: Bool) {
        self.init(seconds: minutes * 60, negative: negative)
    }
    
    init(minutes: Int) {
        self.init(seconds: abs(minutes * 60), negative: minutes < 0)
    }
    
    init(hours: Int, negative: Bool) {
        self.init(seconds: hours * 3600, negative: negative)
    }
    
    init(hours: Int) {
        self.init(seconds: abs(hours * 3600), negative: hours < 0)
    }
    
    init(hours: Int, minutes: Int, negative: Bool) {
        self.init(seconds: hours * 3600 + minutes * 60, negative: negative)
    }
    
    init(hours: Int, minutes: Int) {
        self.init(seconds: abs(hours) * 3600 + abs(minutes) * 60,
                  // != with booleans is XOR: hours OR minutes should be negative, not both
                  negative: (hours < 0) != (minutes < 0))
    }
    
    static let zero = Duration(seconds: 0)
    
    static func + (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.signedSeconds + rhs.signedSeconds)
    }
    
    static func - (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.signedSeconds - rhs.signedSeconds)
    }
    
}
