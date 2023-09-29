//
//  OvertimeRow.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct OvertimeRow: View {
        
    let overtime: Overtime
    
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        HStack {
            // Date
            Text(userData.dateFormatter.string(from: overtime.date))
            Spacer()
            // Time
            Text(JFUtils.timeString(overtime.duration))
        }
    }
}

struct OvertimeRow_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeRow(overtime: Overtime(date: Date(), duration: 2 * .hour + 30 * .minute))
    }
}
