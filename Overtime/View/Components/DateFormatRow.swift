//
//  DateFormatRow.swift
//  Overtime
//
//  Created by Jonas Frey on 09.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DateFormatRow: View {
    // Reference date is the fifth of january in the current year and time zone
    static let referenceDate: Date = {
        let cal = Calendar.current
        var components = cal.dateComponents(in: TimeZone.current, from: Date())
        components.day = 5
        components.month = 1
        return components.date ?? Date()
    }()
    
    let format: String
    let formatter: DateFormatter
    
    init(format: String) {
        self.format = format
        self.formatter = DateFormatter()
        self.formatter.dateFormat = format
    }
    
    var body: some View {
        Text(formatter.string(from: Self.referenceDate))
    }
}

struct DateFormatRow_Previews: PreviewProvider {
    static var previews: some View {
        DateFormatRow(format: "EEEE, d. MMMM yyyy")
    }
}
