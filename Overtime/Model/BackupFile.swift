//
//  BackupFile.swift
//  Overtime
//
//  Created by Jonas Frey on 07.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
import SwiftData
import SwiftUI

/// Represents a backup file that contains Overtime data
struct BackupFile: FileDocument {
    static var readableContentTypes: [UTType] {
        [.json]
    }
    
    var overtimes: [OvertimeRep] = []
    var vacations: [VacationRep] = []
    
    init(overtimeReps: [OvertimeRep], vacationReps: [VacationRep]) {
        self.overtimes = overtimeReps
        self.vacations = vacationReps
    }
    
    init(overtimes: [Overtime], vacations: [Vacation]) {
        self.init(
            overtimeReps: overtimes.map(OvertimeRep.init),
            vacationReps: vacations.map(VacationRep.init)
        )
    }
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        // Try decoding the new format
        do {
            let contents = try decoder.decode(Contents.self, from: data)
            self.overtimes = contents.overtimes
            self.vacations = contents.vacations
        } catch is DecodingError {
            // Try decoding using old format (only overtimes)
            // Errors here are thrown out of the function
            self.overtimes = try decoder.decode([OvertimeRep].self, from: data)
        }
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            // Decode the data from JSON
            try self.init(data: data)
        } else {
            self.init(overtimeReps: [], vacationReps: [])
        }
    }

    func insert(into context: ModelContext) {
        for overtime in overtimes {
            context.insert(overtime.toOvertime())
        }
        for vacation in vacations {
            context.insert(vacation.toVacation())
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // Encode the overtime representations
        let contents = Contents(overtimes: overtimes, vacations: vacations)
        let data = try JSONEncoder().encode(contents)
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

        func toOvertime() -> Overtime {
            Overtime(
                date: date,
                duration: duration
            )
        }
    }
    
    struct VacationRep: Codable {
        let title: String?
        let startDate: Date
        let endDate: Date
        let daysUsed: Double
        
        init(_ vacation: Vacation) {
            self.title = vacation.title
            self.startDate = vacation.startDate
            self.endDate = vacation.endDate
            self.daysUsed = vacation.daysUsed
        }

        func toVacation() -> Vacation {
            Vacation(
                title: title,
                startDate: startDate,
                endDate: endDate,
                daysUsed: daysUsed
            )
        }
    }
    
    struct Contents: Codable {
        var overtimes: [OvertimeRep]
        var vacations: [VacationRep]
    }
}
