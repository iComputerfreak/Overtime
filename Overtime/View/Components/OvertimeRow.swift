//
//  OvertimeRow.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct OvertimeRow: View {
        
    @ObservedObject var overtime: Overtime
    
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        HStack {
            // Date
            Text(userData.dateFormatter.string(from: overtime.date))
            Spacer()
            // Time
            Text(JFUtils.timeString(overtime.duration))
                .foregroundStyle(color(for: overtime.duration))
        }
    }
    
    func color(for duration: TimeInterval) -> Color {
        if duration < 0 {
            return .red
        } else if duration > 0 {
            return .green
        } else {
            return .primary
        }
    }
}

struct OvertimeRow_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeRow(overtime: Overtime(date: Date(), duration: 2 * .hour + 30 * .minute))
    }
}
