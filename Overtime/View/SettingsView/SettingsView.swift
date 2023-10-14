//
//  SettingsView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import JFUtils
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    DateFormatPicker()
                    MonthSectionStylePicker()
                    
                    Section {
                        ImportButton()
                        ExportButton()
                        ResetButton()
                    }
                }
                LegalFooter()
            }
            .navigationTitle("settings.navigationTitle")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData())
    }
}
