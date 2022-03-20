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
        
        // Migrate the old data structure to the new structure
        if !UserDefaults.standard.bool(forKey: migrationV1Key) {
            let overtimes: [Int: [Int: [Overtime]]] = loadV1()
            let migratedOvertimes: [Overtime] = overtimes.values.flatMap({ $0.values.joined() })
            saveV1(migratedOvertimes)
        }
        
        // MARK: Migration 2
        if !UserDefaults.standard.bool(forKey: migrationV2Key) {
            let overtimes: [OldOvertime] = loadV2()
            let migrated = overtimes.map({ Overtime(date: $0.date, duration: Duration(seconds: $0.duration.seconds)) })
            saveV2(migrated)
        }
        
        return true
    }
    
    private func loadV1() -> [Int: [Int: [Overtime]]] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return [:]
        }
        do {
            let values = try PropertyListDecoder().decode([Int: [Int: [Overtime]]].self, from: plist)
            return values
        } catch let e {
            print(e)
            return [:]
        }
    }
    
    private func loadV2() -> [OldOvertime] {
        guard let plist = UserDefaults.standard.value(forKey: JFUtils.overtimesKey) as? Data else {
            return []
        }
        do {
            let values = try PropertyListDecoder().decode([OldOvertime].self, from: plist)
            return values
        } catch let e {
            print(e)
            return []
        }
    }
    
    private func saveV1(_ overtimes: [Overtime]) {
        print("Migrating...")
        do {
            let plist = try PropertyListEncoder().encode(overtimes)
            UserDefaults.standard.set(plist, forKey: JFUtils.overtimesKey)
            UserDefaults.standard.set(true, forKey: migrationV1Key)
        } catch let e {
            print(e)
        }
    }
    
    private func saveV2(_ overtimes: [Overtime]) {
        print("Migrating...")
        do {
            let plist = try PropertyListEncoder().encode(overtimes)
            UserDefaults.standard.set(plist, forKey: JFUtils.overtimesKey)
            UserDefaults.standard.set(true, forKey: migrationV2Key)
        } catch let e {
            print(e)
        }
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

