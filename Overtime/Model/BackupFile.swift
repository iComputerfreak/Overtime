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
    
    var overtimes: [OvertimeRep] = []
    
    init(overtimeReps: [OvertimeRep]) {
        self.overtimes = overtimeReps
    }
    
    init(overtimes: [Overtime]) {
        self.init(overtimeReps: overtimes.map(OvertimeRep.init))
    }
    
    init(data: Data) throws {
        self.overtimes = try JSONDecoder().decode([OvertimeRep].self, from: data)
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            // Decode the data from JSON
            try self.init(data: data)
        } else {
            self.init(overtimeReps: [])
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // Encode the overtime representations
        let data = try JSONEncoder().encode(overtimes)
        return FileWrapper(regularFileWithContents: data)
    }
    
    /// Represents a representation of an ``Overtime`` object that can be exported using Codable
    struct OvertimeRep: Codable {
        let date: Date
        let duration: TimeInterval
        
        init(_ overtime: Overtime) {
            self.date = overtime.date
            self.duration = overtime.duration
        }
    }
}
