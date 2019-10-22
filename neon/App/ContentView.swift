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
    @FetchRequest(entity: HourBlockEntity.entity(), sortDescriptors: []) var pulledBlocks: FetchedResults<HourBlockEntity>
    
    @EnvironmentObject var blocks: HourBlocksStore
    
    @State private var selection = 0
    
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
                .tag(0)
            ToDoListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("To Do")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
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
