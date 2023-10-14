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
    // ISO8601 formatter for the export file name
    static let isoFormatter = ISO8601DateFormatter()
    
    @State private var isExportingFile = false
    @State private var exportingFile: BackupFile?
    
    @Query
    private var overtimes: [Overtime]
    
    var body: some View {
        Button("settings.buttonLabel.export") {
            self.exportingFile = BackupFile(overtimes: overtimes)
            self.isExportingFile = true
        }
        .fileExporter(
            isPresented: $isExportingFile,
            document: exportingFile,
            contentType: .json,
            defaultFilename: "OvertimeBackup_\(Self.isoFormatter.string(from: .now)).json",
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
