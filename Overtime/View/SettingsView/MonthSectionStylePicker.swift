//
//  MonthSectionStylePicker.swift
//  Overtime
//
//  Created by Jonas Frey on 14.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftUI

struct MonthSectionStylePicker: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        Picker("settings.pickerLabel.monthSectionStyle", selection: $userData.monthSectionStyle) {
            ForEach(MonthSectionStyle.allCases, id: \.rawValue) { style in
                Text(style.localized)
                    .tag(style)
            }
        }
    }
}

#Preview {
    MonthSectionStylePicker()
        .environmentObject(UserData())
}
