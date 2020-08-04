//
//  SettingsCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct SettingsCardView: View {
    
    let title: String
    let subtitle: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: title, subtitle: subtitle)
                Spacer()
                IconButton(iconName: iconName, action: action)
            }
        }.padding(.horizontal, 24)
    }
}

struct SettingsCardView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCardView(title: "Calendars", subtitle: "Take control of", iconName: "calendar", action: {})
    }
}
