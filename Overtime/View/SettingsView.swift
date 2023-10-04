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
    
    // ISO8601 formatter for the export file name
    static let isoFormatter = ISO8601DateFormatter()
    
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
    @Environment(\.modelContext) private var context
    
    @State private var isExportingFile = false
    @State private var isImportingFile = false
    @State private var exportingFile: BackupFile?
    @State private var showingResetAlert = false
    
    @Query
    private var overtimes: [Overtime]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    // MARK: Date Format
                    Picker("settings.pickerLabel.dateFormat", selection: $userData.dateFormat) {
                        ForEach(self.dateFormats, id: \.self) { (format: String) in
                            DateFormatRow(format: format)
                                .tag(format)
                        }
                    }
                    
                    // MARK: Month Section Style
                    Picker("settings.pickerLabel.monthSectionStyle", selection: $userData.monthSectionStyle) {
                        ForEach(MonthSectionStyle.allCases, id: \.rawValue) { style in
                            Text(style.localized)
                                .tag(style)
                        }
                    }
                    
                    Section {
                        // MARK: Import
                        Button("settings.buttonLabel.import") {
                            self.isImportingFile = true
                        }
                        .fileImporter(isPresented: $isImportingFile, allowedContentTypes: [.json], onCompletion: importFile(result:))
                        
                        // MARK: Export
                        Button("settings.buttonLabel.export") {
                            self.exportingFile = BackupFile(overtimes: overtimes)
                            self.isExportingFile = true
                        }
                        .fileExporter(
                            isPresented: $isExportingFile,
                            document: exportingFile,
                            contentType: .json,
                            defaultFilename: "OvertimeBackup_\(Self.isoFormatter.string(from: Date())).json",
                            onCompletion: exportFile(result:)
                        )
                        
                        // MARK: Reset
                        Button("settings.buttonLabel.reset") {
                            self.showingResetAlert = true
                        }
                        .alert(
                            "alerts.reset.title",
                            isPresented: $showingResetAlert) {
                                Button("alerts.actions.delete", role: .destructive) {
                                    // Delete entries
                                    userData.reset()
                                }
                                Button("alerts.actions.cancel", role: .cancel) {}
                            } message: {
                                Text("alerts.reset.message")
                            }
                        
                    }
                }
                
                // MARK: Legal Footer
                LegalFooter()
            }
            .navigationTitle("settings.navigationTitle")
        }
    }
    
    func importFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                let data = try Data(contentsOf: url)
                let file = try BackupFile(data: data)
                // Map the OvertimeReps to real Overtimes
                file.overtimes.forEach { rep in
                    let overtime = Overtime(date: rep.date, duration: rep.duration)
                    context.insert(overtime)
                }
            } catch {
                print("Error decoding file.")
                print(error)
                AlertHandler.showError(title: "alerts.errorImporting.title", error: error)
            }
        case .failure(let error):
            print("Error importing backup:")
            print(error)
            AlertHandler.showError(title: "alerts.errorImporting.title", error: error)
        }
    }
    
    func exportFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            print("Exported backup to \(url)")
        case .failure(let error):
            print("Error exporting backup:")
            print(error)
            AlertHandler.showError(title: "alerts.errorExporting.title", error: error)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData())
    }
}
