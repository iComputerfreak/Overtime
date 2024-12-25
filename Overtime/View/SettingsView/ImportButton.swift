//
//  ImportButton.swift
//  Overtime
//
//  Created by Jonas Frey on 14.10.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import JFUtils
import SwiftUI

struct ImportButton: View {
    @State private var isImportingFile = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Button("settings.buttonLabel.import") {
            self.isImportingFile = true
        }
        .fileImporter(isPresented: $isImportingFile, allowedContentTypes: [.json], onCompletion: importFile(result:))
    }
    
    func importFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                let data = try Data(contentsOf: url)
                let file = try BackupFile(data: data)
                file.insert(into: context)
            } catch {
                print("Error decoding file: \(error)")
                AlertHandler.showError(title: String(localized: "alerts.errorImporting.title"), error: error)
            }
        case .failure(let error):
            print("Error importing backup: \(error)")
            AlertHandler.showError(title: String(localized: "alerts.errorImporting.title"), error: error)
        }
    }
}

#Preview {
    ImportButton()
}
