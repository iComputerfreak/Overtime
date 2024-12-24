//
//  Extensions.swift
//  Overtime
//
//  Created by Jonas Frey on 15.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(UserData())
            .modelContainer(previewContainer)
    }
}

extension Range<Date> {
    /// Returns whether this date range overlaps with the given date range at leat partially
    func overlaps(with other: Range<Date>) -> Bool {
        self.lowerBound < other.upperBound && self.upperBound > other.lowerBound
    }
}
