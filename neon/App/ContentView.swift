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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @State private var selection = 0
    
    @State var showWhatsNew = false
    
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableViewCell.appearance().selectionStyle = .none
    }
 
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
                .onAppear(perform: {
                    self.showWhatsNew = DataGateway.shared.isNewVersion()
                })
                .sheet(isPresented: $showWhatsNew, content: {
                    WhatsNewView(showWhatsNew: self.$showWhatsNew)
                })
                .tag(0)
            HabitsView()
                .tabItem {
                    Image(systemName: "bolt")
                    Text("Habits")
                }
                .tag(1)
            ToDoListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("To Do")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
        }.accentColor(Color("primary"))
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
