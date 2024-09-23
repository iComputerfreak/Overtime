//
//  LegalFooter.swift
//  Overtime
//
//  Created by Jonas Frey on 09.01.23.
//  Copyright © 2023 Jonas Frey. All rights reserved.
//

import SwiftUI

struct LegalFooter: View {
    var body: some View {
        HStack {
            Spacer()
            Text("App icon: https://uxwing.com")
                .font(.footnote)
                .padding()
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct LegalFooter_Previews: PreviewProvider {
    static var previews: some View {
        LegalFooter()
    }
}
