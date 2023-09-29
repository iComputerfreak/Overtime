//
//  BackupFile.swift
//  Overtime
//
//  Created by Jonas Frey on 07.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

/// Represents a backup file that contains Overtime data
struct BackupFile: FileDocument {
    
    static var readableContentTypes: [UTType] {
        [.json]
    }
    
    var overtimes: [Overtime] = []
    
    init(overtimes: [Overtime]) {
        self.overtimes = overtimes
    }
    
    init(data: Data) throws {
//        self.overtimes = try JSONDecoder().decode([Overtime].self, from: data)
        self.overtimes = []
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            // Decode the data from JSON
            try self.init(data: data)
        } else {
            self.init(overtimes: [])
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data()// try JSONEncoder().encode(overtimes)
        return FileWrapper(regularFileWithContents: data)
    }
}
