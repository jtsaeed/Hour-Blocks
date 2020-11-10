//
//  SettingsCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 22/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view for displaying a Settings section.
struct SettingsCardView: View {
    
    private let title: String
    private let subtitle: String
    private let iconName: String
    private let action: () -> Void
    
    /// Creates an instance of SettingsCardView.
    ///
    /// - Parameters:
    ///   - title: The text string for the main label on the bottom.
    ///   - subtitle: The text string for the secondary label at the top.
    ///   - iconName: The SF Symbol name of the icon to be used as part of the Card's trailing IconButton.
    ///   - action: The callback function to be triggered when the user has tapped on the Card's trailing IconButton.
    init(title: String, subtitle: String, iconName: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.action = action
    }
    
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
