//
//  MonthSectionStyle.swift
//  Overtime
//
//  Created by Jonas Frey on 04.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

enum MonthSectionStyle: String, CaseIterable {
    case monthSections
    case monthDisclosureGroups
    
    static let defaultValue = Self.monthDisclosureGroups
    
    var localized: String {
        switch self {
        case .monthSections:
            return String(localized: "monthSectionStyle.monthSections", comment: "A style that displays the individual months as separate sections in a list.")
        case .monthDisclosureGroups:
            return String(localized: "monthSectionStyle.monthDisclosureGroups", comment: "A style that displays the individual months as disclosure groups in a list.")
        }
    }
}

// MARK: - Environment

struct MonthSectionStyleKey: EnvironmentKey {
    typealias Value = MonthSectionStyle
    static var defaultValue = MonthSectionStyle.defaultValue
}

extension EnvironmentValues {
  var monthSectionStyle: MonthSectionStyle {
    get { self[MonthSectionStyleKey.self] }
    set { self[MonthSectionStyleKey.self] = newValue }
  }
}
