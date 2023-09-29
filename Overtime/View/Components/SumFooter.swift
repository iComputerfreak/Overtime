//
//  SumFooter.swift
//  Overtime
//
//  Created by Jonas Frey on 29.09.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftData
import SwiftUI

struct SumFooter: View {
    @Query private var overtimes: [Overtime]
    
    var totalDuration: TimeInterval {
        overtimes.map(\.duration).reduce(0, +)
    }
    
    var body: some View {
        HStack {
            Text("overtimes.totalPrefix")
                .bold()
            Spacer()
            Text(JFUtils.timeString(totalDuration))
                .bold()
        }
        .padding(.horizontal)
    }
}

#Preview {
    SumFooter()
}
