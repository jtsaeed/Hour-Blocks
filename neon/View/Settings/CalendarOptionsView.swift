//
//  NewCalendarOptionsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct CalendarOptionsView: View {
    
    @Binding var isPresented: Bool
    
    @StateObject var viewModel = CalendarOptionsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.calendarGateway.hasPermission() {
                        ForEach(viewModel.allCalendars.sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                            CalendarCard(calendarTitle: calendar.title,
                                         isEnabled: viewModel.enabledCalendars[calendar.calendarIdentifier] ?? true,
                                         onValueChanged: { updateCalendar(for: calendar.calendarIdentifier, with: $0) })
                        }
                    } else {
                        NoPermissionsCard()
                    }
                }.padding(.vertical, 24)
            }.navigationBarTitle("Calendars", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    func updateCalendar(for calendarIdentifier: String, with value: Bool) {
        viewModel.updateCalendar(for: calendarIdentifier, with: value)
    }
    
    func dismiss() {
        isPresented = false
    }
}

private struct CalendarCard: View {
    
    @State var isEnabled: Bool
    
    let calendarTitle: String
    let onValueChanged: (Bool) -> Void
    
    init(calendarTitle: String, isEnabled: Bool, onValueChanged: @escaping (Bool) -> Void) {
        self._isEnabled = State<Bool>(initialValue: isEnabled)
        
        self.calendarTitle = calendarTitle
        self.onValueChanged = onValueChanged
    }
    
    var body: some View {
        Card {
            HStack {
                Text(calendarTitle)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))
                    .onChange(of: isEnabled) { _ in toggleChanged() }
                    .frame(width: 40)
            }
        }.padding(.horizontal, 24)
    }
    
    func toggleChanged() {
        self.onValueChanged(isEnabled)
    }
}

private struct NoPermissionsCard: View {
    
    var body: some View {
        Card {
            HStack {
                Text("Calendar access hasn't been enabled")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                IconButton(iconName: "lock.fill", action: openPermissionSettings)
            }
        }.padding(.horizontal, 24)
    }
    
    func openPermissionSettings() {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct CalendarOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarOptionsView(isPresented: .constant(true))
    }
}
