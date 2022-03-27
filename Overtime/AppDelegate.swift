//
//  AppDelegate.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import UIKit

struct OldOvertime: Decodable {
    let date: Date
    let duration: OldDuration
}

struct OldDuration: Decodable {
    let seconds: Int
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let migrationV1Key = "migrationV1"
    let migrationV2Key = "migrationV2"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Migration
        if !UserDefaults.standard.bool(forKey: migrationV2Key) {
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
        
        return true
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
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

