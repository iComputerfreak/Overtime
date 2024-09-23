//
//  TimeSheetUITests.swift
//  TimeSheetUITests
//
//  Created by Jonas Frey on 03.01.23.
//

import XCTest

final class OvertimeUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var screenshotCounter: Int!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--screenshots"]
        setupSnapshot(app)
        screenshotCounter = 1
    }

    func testTakeAppStoreScreenshots() throws {
        app.launch()
        // Take the screenshots
        snapshot("Overtimes")
        
        app.navigationBars.buttons["add"].forceTap()
        app.buttons["time-based"].tap()
        snapshot("Create_Entry_Time")
        app.navigationBars.buttons.firstMatch.tap()
        
        app.navigationBars.buttons["payout-button"].tap()
        snapshot("Create_Payout")
        app.swipeDown(velocity: .fast)
        
        // TODO: Fix
        app.tabBars.buttons["payouts-tab"].tap()
        snapshot("Payouts")
        
        app.tabBars.buttons["history-tab"].tap()
        snapshot("History")
        
        app.tabBars.buttons["settings-tab"].tap()
        snapshot("Settings")
    }
    
    // Take a snapshot with a global increasing counter as a prefix
    private func snapshot(_ name: String) {
        Snapshot.snapshot("\(String(format: "%02d", screenshotCounter))_\(name)")
        screenshotCounter += 1
    }
}

extension XCUIElement {
    func forceTap() {
        coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5)).tap()
    }
}
