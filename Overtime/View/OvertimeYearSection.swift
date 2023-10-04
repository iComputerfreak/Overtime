//
//  OvertimeYearSection.swift
//  Overtime
//
//  Created by Jonas Frey on 29.09.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

struct OvertimeYearSection: View {
    @Environment(\.monthSectionStyle) private var monthSectionStyle
    
    let year: Int
    @Binding var config: OvertimeViewConfig
    
    @Query
    var overtimes: [Overtime]
    
    var months: [Int] {
        overtimes
            .map { $0.date[.month] }
            .removingDuplicates()
            .sorted(by: >)
    }
    
    init(year: Int, config: Binding<OvertimeViewConfig>) {
        self.year = year
        self._config = config
        self._overtimes = Query(
            filter: Overtime.predicate(for: year),
            sort: \Overtime.date,
            order: .reverse
        )
    }
    
    var body: some View {
        switch monthSectionStyle {
        case .monthSections:
            self.content
        case .monthDisclosureGroups:
            Section(header: Text(verbatim: "\(year.description)")) {
                self.content
            }
        }
    }
    
    var content: some View {
        ForEach(months, id: \.self) { (month: Int) in
            OvertimeMonthSection(year: year, month: month, config: $config)
        }
    }
}

#Preview {
    OvertimeYearSection(year: 2023, config: .constant(.init()))
}

