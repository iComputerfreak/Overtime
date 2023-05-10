//
//  SettingsView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI
import JFUtils
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
    @State private var isExportingFile = false
    @State private var isImportingFile = false
    @State private var exportingFile: BackupFile?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    // MARK: Date Format
                    Picker("settings.pickerLabel.dateFormat", selection: $userData.dateFormat) {
                        ForEach(self.dateFormats, id: \.self) { (format: String) in
                            DateFormatRow(format: format)
                                .tag(format)
                        }
                    }
                    
                    // MARK: Import
                    Button("settings.buttonLabel.import") {
                        self.isImportingFile = true
                    }
                    .fileImporter(isPresented: $isImportingFile, allowedContentTypes: [.json], onCompletion: importFile(result:))
                    
                    // MARK: Export
                    Button("settings.buttonLabel.export") {
                        self.exportingFile = BackupFile(overtimes: userData.overtimes)
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
                    Section {
                        Button("settings.buttonLabel.reset", action: resetData)
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
                userData.overtimes.append(contentsOf: file.overtimes)
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
    
    func resetData() {
        let alert = UIAlertController(
            title: "alerts.reset.title",
            message: "alerts.reset.message",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "alerts.actions.delete", style: .destructive, handler: { (_) in
            // Delete entries
            userData.reset()
        }))
        alert.addAction(.init(title: "alerts.actions.cancel", style: .cancel))
        AlertHandler.presentAlert(alert: alert)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData.preview)
    }
}
