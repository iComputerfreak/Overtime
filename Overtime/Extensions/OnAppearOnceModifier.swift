// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation
import SwiftUI

struct OnAppearOnceModifier: ViewModifier {
    @State private var hasAppeared: Bool = false
    let closure: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }

            closure()
            hasAppeared = true
        }
    }
}

extension View {
    func onAppearOnce(_ closure: @escaping () -> Void) -> some View {
        modifier(OnAppearOnceModifier(closure: closure))
    }
}
