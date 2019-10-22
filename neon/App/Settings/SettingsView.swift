//
//  SettingsView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        List {
            Section(header: Header(title: "Settings", subtitle: "3.0 BETA 2")) {
                SettingsCard(title: "Permissions", subtitle: "Take control of", icon: "settings_permissions")
                SettingsCard(title: "Calendars", subtitle: "Take control of", icon: "settings_calendars")
                SettingsCard(title: "Other Stuff", subtitle: "Take control of", icon: "settings_other")
                SettingsCard(title: "Twitter", subtitle: "Follow me on", icon: "settings_twitter")
            }
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
