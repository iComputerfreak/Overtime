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
                    Text("Überstunden")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Einstellungen")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
