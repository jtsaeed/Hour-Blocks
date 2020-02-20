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
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    
    var body: some View {
        NavigationView {
            List {
                if CalendarGateway.shared.hasPermission() {
                    ForEach(CalendarGateway.shared.getAllCalendars().sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                        CalendarCard(calendar: calendar)
                    }
                } else {
                    SettingsCard(title: "Permissions",
                                 subtitle: "Enable calendar",
                                 iconName: "privacy_icon",
                                 tapped: openPermissionsSettings)
                }
            }
            .navigationBarItems(trailing: Button(action: dismiss, label: {
                Text("Done")
            }))
            .navigationBarTitle("Calendars")
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func openPermissionsSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

private struct CalendarCard: View {
    
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var viewModel: SettingsViewModel
    
    let calendar: EKCalendar
    
    @State var isEnabled = true
    
    var body: some View {
        DispatchQueue.main.async {
            self.isEnabled = self.viewModel.enabledCalendars[self.calendar.calendarIdentifier] ?? true
        }
        
        return Card {
            HStack {
                Text(self.calendar.title).modifier(CardTitleLabel())
                Spacer()
                IconToggle(enabled: self.$isEnabled,
                           iconName: "calendar_item",
                           action: self.toggle)
            }
        }
    }
    
    func toggle() {
        HapticsGateway.shared.triggerLightImpact()
        isEnabled.toggle()
        viewModel.toggleCalendar(for: calendar.calendarIdentifier, to: isEnabled)
        scheduleViewModel.loadHourBlocks()
    }
}

/*
struct CalendarCard: View {
    
    @State var isEnabled: Bool
    
    let name: String
    
    var didToggle: (Bool) -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $isEnabled) {
                Text(name)
                .lineLimit(1)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            }.onTapGesture {
                self.didToggle(!self.isEnabled)
            }
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color("title"))
                .opacity(0.05)
                .padding(.vertical, 4)
        }.padding(.horizontal, 16)
    }
}
*/
