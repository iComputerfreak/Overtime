//
//  Extensions.swift
//  Overtime
//
//  Created by Jonas Frey on 15.03.22.
//  Copyright © 2022 Jonas Frey. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(UserData())
            .modelContainer(previewContainer)
    }
}
