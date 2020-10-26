//
//  NewCalendarOptionsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view allowing the user to toggle which of their calendars are to be shown within Hour Blocks.
struct CalendarSettingsView: View {
    
    @StateObject private var viewModel = CalendarOptionsViewModel()
    
    @Binding private var isPresented: Bool
    
    /// Creates an instance of CalendarOptionsView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.calendarAccessGranted() {
                        ForEach(viewModel.allCalendars.sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                            CalendarCard(isEnabled: viewModel.enabledCalendars[calendar.calendarIdentifier] ?? true,
                                         calendarTitle: calendar.title,
                                         onValueChanged: { updateCalendar(for: calendar.calendarIdentifier, with: $0) })
                        }
                    } else {
                        NoPermissionsCard()
                    }
                }.padding(.vertical, 24)
            }.navigationBarTitle("Calendars", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismiss)
                }
            }
        }.accentColor(Color("AccentColor"))
    }
    
    /// Performs a request to update whether or not a specific calendar is enabled or not.
    ///
    /// - Parameters:
    ///   - calendarIdentifier: The unique string identifier of the calendar for which the status is to be updated.
    ///   - value: The value determining whether or not the calendar is set to be enabled or not.
    private func updateCalendar(for calendarIdentifier: String, with value: Bool) {
        viewModel.updateCalendar(for: calendarIdentifier, with: value)
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

/// A Card based view allowing the user to toggle a particular calendar's selected state.
private struct CalendarCard: View {
    
    @State private var isEnabled: Bool
    
    private let calendarTitle: String
    private let onValueChanged: (Bool) -> Void
    
    /// Creates an instance of the CalendarCard view.
    ///
    /// - Parameters:
    ///   - isEnabled : The initial value of whether or not the corresponding calendar is selected.
    ///   - calendarTitle: The title of the corresponding calendar.
    ///   - onValueChanegd: The callback function to be triggered when the value of the trailing toggle view has been changed.
    init(isEnabled: Bool, calendarTitle: String, onValueChanged: @escaping (Bool) -> Void) {
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
    
    /// Performs the toggle request.
    private func toggleChanged() {
        onValueChanged(isEnabled)
    }
}

/// A Card based view that allows the user to prompts the user to grant calendar access.
private struct NoPermissionsCard: View {
    
    var body: some View {
        Card {
            HStack {
                Text("Calendar access hasn't been granted")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                IconButton(iconName: "lock.fill",
                           action: openPermissionSettings)
            }
        }.padding(.horizontal, 24)
    }
    
    /// Opens the Hour Blocks section of the Settings app.
    private func openPermissionSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct CalendarOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSettingsView(isPresented: .constant(true))
    }
}
