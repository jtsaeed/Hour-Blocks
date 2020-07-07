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
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
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
            NewScheduleView().tabItem {
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
        }.accentColor(Color("primary"))
        .onAppear(perform: checkIfUpdated)
        .sheet(isPresented: $showWhatsNew, content: {
            WhatsNewView(showWhatsNew: self.$showWhatsNew)
        })
    }
    
    func checkIfUpdated() {
        self.showWhatsNew = DataGateway.shared.isNewVersion()
        
        if showWhatsNew {
            scheduleViewModel.currentTip = .swipeBlockOptions
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
