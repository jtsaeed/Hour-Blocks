//
//  IconButton.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

/// The circular coloured icon button used throughout Hour Blocks.
struct IconButton: View {
    
    private let iconName: String
    private let iconWeight: Font.Weight
    private let iconColor: String
    
    private let action: () -> Void
    
    /// Creates an instance of the IconButton view.
    ///
    /// - Parameters:
    ///   - iconName: The SF Symbol name of the icon to be used.
    ///   - iconWeight: The weight of the icon. By default, this is set to regular.
    ///   - iconColor: The color of the icon. By default, this is set to be the accent color.
    ///   - action: The callback function to be triggered when the user has tapped on the button.
    init(iconName: String, iconWeight: Font.Weight = .regular, iconColor: String = "AccentColor", action: @escaping () -> Void) {
        self.iconName = iconName
        self.iconWeight = iconWeight
        self.iconColor = iconColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .foregroundColor(Color("\(iconColor)Light"))
                    .frame(width: 40, height: 40)
                Image(systemName: iconName)
                    .foregroundColor(Color(iconColor))
                    .font(.system(size: 20, weight: iconWeight, design: .rounded))
            }
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(iconName: "plus", action: { print("test") })
    }
}
