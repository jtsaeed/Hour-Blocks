//
//  CalendarSettingsView.swift
//  neon
//
//  Created by James Saeed on 30/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit

struct CalendarSettingsView: View {
    
    @State var enabledCalendars: [String: Bool]?
    
    init() {
        enabledCalendars = DataGateway.shared.loadEnabledCalendars()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(CalendarGateway.shared.getAllCalendars().sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                    CalendarCard(isEnabled: self.enabledCalendars?[calendar.calendarIdentifier] ?? true, name: calendar.title, didToggle: { status in
                        self.toggleCalendar(for: calendar.calendarIdentifier, to: status)
                    })
                }
            }
            .navigationBarTitle("Calendars")
        }
    }
    
    private func toggleCalendar(for identifier: String, to status: Bool) {
        if enabledCalendars == nil {
            initialiseEnabledCalendars()
        }
        
        enabledCalendars?[identifier] = status
        
        DataGateway.shared.saveEnabledCalendars(enabledCalendars!)
    }
    
    private func initialiseEnabledCalendars() {
        enabledCalendars = [String: Bool]()
            
        for calendar in CalendarGateway.shared.getAllCalendars() {
            enabledCalendars?[calendar.calendarIdentifier] = true
        }
    }
}

struct CalendarCard: View {
    
    @State var isEnabled: Bool
    
    let name: String
    
    var didToggle: (Bool) -> ()
    
    var body: some View {
        ZStack {
            SoftCard(cornerRadius: 20)
            HStack {
                Text(name)
                    .lineLimit(1)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                Spacer()
                Toggle(isOn: $isEnabled) {
                    Text("")
                }.onTapGesture {
                    self.didToggle(self.isEnabled)
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}
