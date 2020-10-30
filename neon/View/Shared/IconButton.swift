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
    private let iconColor: Color
    
    private let action: () -> Void
    
    /// Creates an instance of the IconButton view.
    ///
    /// - Parameters:
    ///   - iconName: The SF Symbol name of the icon to be used.
    ///   - iconWeight: The weight of the icon. By default, this is set to regular.
    ///   - iconColor: The color of the icon. By default, this is set to be the accent color.
    ///   - action: The callback function to be triggered when the user has tapped on the button.
    init(iconName: String, iconWeight: Font.Weight = .regular, iconColor: Color = Color(AppStrings.Colors.accent), action: @escaping () -> Void) {
        self.iconName = iconName
        self.iconWeight = iconWeight
        self.iconColor = iconColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
        }.buttonStyle(IconButtonStyle(iconWeight: iconWeight, iconColor: iconColor))
    }
}

private struct IconButtonStyle: ButtonStyle {
    
    /// Environment variable identifying the current device colour scheme between dark or light mode.
    @Environment(\.colorScheme) var colorScheme
    
    let iconWeight: Font.Weight
    let iconColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(iconColor.getLightColor(darkMode: colorScheme == .dark))
                .opacity(configuration.isPressed ? 0.5 : 1)
                .frame(width: 40, height: 40)
            configuration.label
                .foregroundColor(iconColor)
                .opacity(configuration.isPressed ? 0.75 : 1)
                .font(.system(size: 20, weight: iconWeight, design: .rounded))
        }.scaleEffect(configuration.isPressed ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.2))
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(iconName: AppStrings.Icons.add, action: { print("test") })
    }
}
