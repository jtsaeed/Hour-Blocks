//
//  NewCalendarOptionsView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewCalendarOptionsView: View {
    
    @Binding var isPresented: Bool
    
    @StateObject var viewModel = CalendarOptionsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(viewModel.allCalendars.sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                        CalendarCard(calendarTitle: calendar.title,
                                     isEnabled: viewModel.enabledCalendars[calendar.calendarIdentifier] ?? true,
                                     onValueChanged: { updateCalendar(for: calendar.calendarIdentifier, with: $0) })
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
    
    let calendarTitle: String
    @State var isEnabled: Bool
    let onValueChanged: (Bool) -> Void
    
    init(calendarTitle: String, isEnabled: Bool, onValueChanged: @escaping (Bool) -> Void) {
        self.calendarTitle = calendarTitle
        self._isEnabled = State<Bool>(initialValue: isEnabled)
        self.onValueChanged = onValueChanged
    }
    
    var body: some View {
        NewCard {
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

struct NewCalendarOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NewCalendarOptionsView(isPresented: .constant(true))
    }
}
