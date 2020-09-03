//
//  TestSidebarView.swift
//  Hour Blocks
//
//  Created by James Saeed on 04/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct TestSidebarView: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ScheduleView()) {
                    Label("Schedule", systemImage: "calendar")
                }
                
                NavigationLink(destination: ToDoListView()) {
                    Label("To Do List", systemImage: "list.bullet")
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: CalendarOptionsView(isPresented: .constant(true))) {
                        Label("Calendars", systemImage: "calendar")
                    }
                    
                    NavigationLink(destination: OtherSettingsView(isPresented: .constant(true))) {
                        Label("Other Stuff", systemImage: "gearshape.fill")
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView(isPresented: .constant(true))) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                    }
                }
            }.listStyle(SidebarListStyle())
            .navigationTitle("Menu")
            
            ScheduleView()
        }.accentColor(Color("AccentColor"))
    }
    
    func toggleSidebar() {
//        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct TestSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        TestSidebarView().previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)"))
    }
}
