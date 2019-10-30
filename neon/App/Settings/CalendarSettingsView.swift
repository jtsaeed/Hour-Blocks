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
    
    var body: some View {
        List {
            ForEach(CalendarGateway.shared.getAllCalendars(), id: \.self) { calendar in
                CalendarCard(name: calendar.title)
            }
        }
    }
}

struct CalendarCard: View {
    
    @State var isEnabled = true
    
    let name: String
    
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
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}
