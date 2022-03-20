//
//  Duration.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import Foundation

struct Duration: AdditiveArithmetic, Codable {
    
    let negative: Bool
    let seconds: Int
    
    var signedSeconds: Int { negative ? -seconds : seconds }
    
    var minutes: Int {
        return seconds / 60
    }
    
    var hours: Int {
        return minutes / 60
    }
    
    init(seconds: Int) {
        self.negative = seconds < 0
        self.seconds = abs(seconds)
    }
    
    init(seconds: Int, negative: Bool) {
        self.init(seconds: negative ? -seconds : seconds)
    }
    
    init(minutes: Int, negative: Bool = false) {
        self.init(seconds: minutes * 60, negative: negative)
    }
    
    init(hours: Int, negative: Bool = false) {
        self.init(seconds: hours * 3600, negative: negative)
    }
    
    init(hours: Int, minutes: Int, negative: Bool = false) {
        self.init(seconds: hours * 3600 + minutes * 60, negative: negative)
    }
    
    
    static let zero = Duration(seconds: 0)
    
    static func + (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.signedSeconds + rhs.signedSeconds)
    }
    
    static func - (lhs: Duration, rhs: Duration) -> Duration {
        return Duration(seconds: lhs.signedSeconds - rhs.signedSeconds)
    }
    
}
