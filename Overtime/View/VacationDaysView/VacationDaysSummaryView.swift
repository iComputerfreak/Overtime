// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

struct VacationDaysSummaryView: View {
    let days: Double
    
    var body: some View {
        VStack {
            Text("vacation.summary \(days)")
                .font(.system(size: 52))
            Text("vacation.remainingSuffix")
                .font(.title)
        }
        .fontWeight(.medium)
        .foregroundStyle(.green)
    }
}

#Preview {
    VacationDaysSummaryView(days: 28.4999999)
}
