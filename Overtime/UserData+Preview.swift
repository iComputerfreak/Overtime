//
//  UserData+Preview.swift
//  Overtime
//
//  Created by Jonas Frey on 09.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import Foundation
import JFUtils

extension UserData {
    static let preview: UserData = {
        let u = UserData()
//        u.overtimes = [
//            .init(date: .now, duration: .init(hours: 2, minutes: 30)),
//            .init(date: .now.addingTimeInterval(-1 * .day), duration: .init(hours: 1, minutes: 45)),
//            .init(date: .now.addingTimeInterval(-2 * .day), duration: .init(hours: 3, minutes: 0)),
//            .init(date: .now.addingTimeInterval(-3 * .day), duration: .init(hours: 0, minutes: 15)),
//        ]
//        // formIndex syntax
//        u.monthCollapseStates = u.overtimes.map { "\($0.date[.year])_\($0.date[.month])" }.removingDuplicates()
//        u.weekCollapseStates = u.overtimes.map { "\($0.date[.year])_\($0.date[.weekOfYear])" }.removingDuplicates()
        return u
    }()
}
