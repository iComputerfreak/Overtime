//
//  ContentView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            OvertimeView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("tabView.overtimes.label")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("tabView.settings.label")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData.preview)
    }
}
