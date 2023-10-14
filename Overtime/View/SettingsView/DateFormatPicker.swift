//
//  DateFormatPicker.swift
//  Overtime
//
//  Created by Jonas Frey on 14.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DateFormatPicker: View {
    // Available date formats
    let dateFormats: [String] = [
        "EEEE, d. MMMM yyyy", // Sunday, 5. January 2020
        "E, d. MMM yyyy", // Sun, 5. Jan 2020
        "E, d. MMM", // Sun, 5. Jan
        "d. MMMM yyyy", // 5. January 2020
        "d. MMM yyyy", // 5. Jan 2020
        "d. MMMM", // 5 January
        "d.M.yyyy", // 5.1.2020
        "dd.MM.yyyy", // 05.01.2020
        "d.M.yy", // 5.1.20
        "dd.MM.yy", // 05.01.20
        "d.M", // 5.1.
        "yyyy-MM-dd", // 2020-01-05
    ]
    
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        Picker("settings.pickerLabel.dateFormat", selection: $userData.dateFormat) {
            ForEach(self.dateFormats, id: \.self) { (format: String) in
                DateFormatRow(format: format)
                    .tag(format)
            }
        }
    }
}

#Preview {
    DateFormatPicker()
        .environmentObject(UserData())
}
