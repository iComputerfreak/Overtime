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
                    Picker("Datumsformat", selection: $userData.dateFormat) {
                        ForEach(self.dateFormats, id: \.self) { (format: String) in
                            DateFormatRow(format: format)
                                .tag(format)
                        }
                    }
                    
                    // MARK: Import
                    Button("Importieren") {
                        self.isImportingFile = true
                    }
                    .fileImporter(isPresented: $isImportingFile, allowedContentTypes: [.json], onCompletion: importFile(result:))
                    
                    // MARK: Export
                    Button("Exportieren") {
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
                        Button("Zurücksetzen", action: resetData)
                    }
                }
                
                // MARK: Legal Footer
                LegalFooter()
            }
            .navigationTitle("Einstellungen")
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
                // TODO: Show alert
            }
        case .failure(let error):
            print("Error importing backup:")
            print(error)
            // TODO: Show alert
        }
    }
    
    func exportFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            print("Exported backup to \(url)")
        case .failure(let error):
            print("Error exporting backup:")
            print(error)
            // TODO: Show alert
        }
    }
    
    func resetData() {
        let alert = UIAlertController(
            title: "Überstunden löschen?",
            message: "Mit dieser Aktion werden alle Überstunden unwiderruflich gelöscht. Wollen sie fortfahren?",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Löschen", style: .destructive, handler: { (_) in
            // Delete entries
            userData.reset()
        }))
        alert.addAction(.init(title: "Abbrechen", style: .cancel))
        AlertHandler.presentAlert(alert: alert)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData.preview)
    }
}
