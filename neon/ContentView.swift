//
//  ContentView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let debug = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var showWhatsNew = VersionGateway.shared.isNewVersion()
 
    var body: some View {
        TabView {
            ScheduleView().tabItem {
                Image(systemName: "calendar")
                Text("Schedule")
            }
            ToDoListView().tabItem {
                Image(systemName: "list.bullet")
                Text("To Do List")
            }
            SettingsView().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }.accentColor(Color("AccentColor"))
        .sheet(isPresented: $showWhatsNew, content: {
            WhatsNewView(showWhatsNew: self.$showWhatsNew)
        })
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
