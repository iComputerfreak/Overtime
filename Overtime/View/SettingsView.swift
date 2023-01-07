//
//  SettingsView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    // Reference date is the fifth of january
    static let referenceDate: Date = {
        let cal = Calendar.current
        var components = cal.dateComponents(in: TimeZone.current, from: Date())
        components.day = 5
        components.month = 1
        return components.date ?? Date()
    }()
    
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
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Picker("Datumsformat", selection: $userData.dateFormat) {
                        ForEach(self.dateFormats, id: \.self) { (format: String) in
                            DateFormatRow(format: format)
                                .tag(format)
                        }
                    }
                    Button("Export") {
                        self.exportOvertimes()
                    }
                    Section {
                        Button("Zurücksetzen") {
                            let alert = UIAlertController(title: "Überstunden löschen?", message: "Mit dieser Aktion werden alle Überstunden unwiderruflich gelöscht. Wollen sie fortfahren?", preferredStyle: .alert)
                            alert.addAction(.init(title: "Löschen", style: .destructive, handler: { (_) in
                                // Delete entries
                                UserDefaults.standard.set(nil, forKey: JFUtils.overtimesKey)
                                JFUtils.overtimesInvalidated = true
                            }))
                            alert.addAction(.init(title: "Abbrechen", style: .cancel))
                            AlertHandler.presentAlert(alert: alert)
                        }
                    }
                }
                HStack(spacing: 0) {
                    Spacer()
                    Text("App icon: Flaticon.com")
                        .font(.footnote)
                        .padding()
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("Einstellungen")
        }
    }
    
    func exportOvertimes() {
        
    }
}

struct DateFormatRow: View {
    
    let format: String
    var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = format
        return f
    }
    var example: String {
        formatter.string(from: SettingsView.referenceDate)
    }
    
    var body: some View {
        Text(example)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
