//
//  ContentView.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        TabView {
            OvertimeView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("tabView.overtimes.label")
                }

            VacationDaysView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("tabView.vacationDays.label")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("tabView.settings.label")
                }
        }
        .environment(\.monthSectionStyle, userData.monthSectionStyle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
