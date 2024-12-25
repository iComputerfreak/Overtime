//
//  ExportButton.swift
//  Overtime
//
//  Created by Jonas Frey on 14.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import JFUtils
import SwiftData
import SwiftUI

struct ExportButton: View {
    @State private var isExportingFile = false
    @State private var exportingFile: BackupFile?
    
    @Query
    private var overtimes: [Overtime]
    @Query
    private var vacations: [Vacation]

    var cleanDate: String {
        Date.now.formatted(.iso8601).replacingOccurrences(of: ":", with: "_")
    }

    var body: some View {
        Button("settings.buttonLabel.export") {
            self.exportingFile = BackupFile(overtimes: overtimes, vacations: vacations)
            self.isExportingFile = true
        }
        .fileExporter(
            isPresented: $isExportingFile,
            document: exportingFile,
            contentType: .json,
            // We omit the ":" time separator, as it is not allowed on macOS/iOS files
            defaultFilename: "OvertimeBackup_\(cleanDate).json",
            onCompletion: exportFile(result:)
        )
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

#Preview {
    ExportButton()
}
