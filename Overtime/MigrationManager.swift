//
//  MigrationManager.swift
//  Overtime
//
//  Created by Jonas Frey on 27.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import Foundation
import JFUtils

struct MigrationManager {
    
    private let migrationV1Key = "migrationV1"
    private let migrationV2Key = "migrationV2"
    
    func migrate() {
        // MARK: Migration
        if !UserDefaults.standard.bool(forKey: migrationV2Key) {
            print("Migrating...")
            do {
                let overtimes: [Int: [Int: [OldOvertime]]] = try load()
                var migrated: [Overtime] = []
                for i in overtimes.values {
                    for j in i.values {
                        for overtime in j {
                            migrated.append(Overtime(
                                date: overtime.date,
                                duration: Duration(seconds: overtime.duration.seconds))
                            )
                        }
                    }
                }
                try save(migrated)
                UserDefaults.standard.set(true, forKey: migrationV1Key)
                UserDefaults.standard.set(true, forKey: migrationV2Key)
            } catch let e {
                print(e)
                AlertHandler.showSimpleAlert(
                    title: "Fehler beim Migrieren.",
                    message: "Fehler beim Migrieren der alten Daten. Daten werden nicht überschrieben.")
                fatalError()
            }
        }
    }
    
    private func load() throws -> [Int: [Int: [OldOvertime]]] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return [:]
        }
        let values = try PropertyListDecoder().decode([Int: [Int: [OldOvertime]]].self, from: plist)
        return values
    }
    
    private func save(_ overtimes: [Overtime]) throws {
        print("Migrating...")
        let plist = try PropertyListEncoder().encode(overtimes)
        UserDefaults.standard.set(plist, forKey: JFUtils.overtimesKey)
    }
    
}

struct OldOvertime: Decodable {
    let date: Date
    let duration: OldDuration
}

struct OldDuration: Decodable {
    let seconds: Int
}
