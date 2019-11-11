//
//  SettingsView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @State var isCalendarsPresented = false
    @State var isOtherStuffPresented = false
    
    var body: some View {
        List {
            Section(header: Header(title: "Settings", subtitle: "3.0 BETA 3")) {
                SettingsCard(title: "Permissions", subtitle: "Take control of", icon: "settings_permissions")
                    .onTapGesture {
                        self.openPermissionsSettings()
                    }
                SettingsCard(title: "Calendars", subtitle: "Take control of", icon: "settings_calendars")
                    .onTapGesture {
                        self.isCalendarsPresented.toggle()
                    }
                    .sheet(isPresented: $isCalendarsPresented, content: {
                        CalendarSettingsView(isPresented: self.$isCalendarsPresented)
                            .environmentObject(self.blocks)
                            .environmentObject(self.settings)
                    })
                SettingsCard(title: "Other Stuff", subtitle: "Take control of", icon: "settings_other")
                    .onTapGesture {
                        self.isOtherStuffPresented.toggle()
                    }
                    .sheet(isPresented: $isOtherStuffPresented, content: {
                        OtherSettingsView(isPresented: self.$isOtherStuffPresented, timeFormatValue: self.settings.other[OtherSettingsKey.timeFormat.rawValue]!)
                            .environmentObject(self.blocks)
                            .environmentObject(self.settings)
                    })
                SettingsCard(title: "Twitter", subtitle: "Follow me on", icon: "settings_twitter")
                    .onTapGesture {
                        self.openTwitter()
                    }
            }
        }
    }
    
    func openPermissionsSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openTwitter() {
        if let url = URL(string: "https://twitter.com/j_t_saeed") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: title, subtitle: subtitle.uppercased())
                Spacer()
                Image(icon)
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

#if DEBUG
struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
