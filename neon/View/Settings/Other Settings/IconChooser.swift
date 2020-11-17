//
//  IconChooser.swift
//  Hour Blocks
//
//  Created by James Saeed on 30/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view allowing the user to choose from a set of app icons.
struct IconChooserCard: View {
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(AppStrings.Settings.appIconChooserTitle)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(AppStrings.Settings.appIconChooserContent)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72, maximum: 112))], spacing: 24) {
                    ForEach(IconOption.allCases, id: \.self) { iconOption in
                        IconOptionView(for: iconOption)
                    }
                }
            }
        }.padding(.horizontal, 24)
    }
}

/// A tile view for a selectable icon.
private struct IconOptionView: View {
    
    private let iconOption: IconOption
    
    /// Creates an instance of the IconOption view.
    ///
    /// - Parameters:
    ///   - iconOption: The icon option to display the information for and to change.
    init(for iconOption: IconOption) {
        self.iconOption = iconOption
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Button(action: setIcon) {
                Image("choose_\(iconOption.imageName)_icon")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(12)
            }
            Text(iconOption.label)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .opacity(0.5)
        }
    }
    
    /// Sets the icon when the tile gets tapped.
    private func setIcon() {
        HapticsGateway.shared.triggerAddBlockHaptic()
        
        let iconFileName = iconOption == .original ? nil : "icon_\(iconOption.imageName)"
        UIApplication.shared.setAlternateIconName(iconFileName, completionHandler: nil)
    }
}

private enum IconOption: String, CaseIterable {
    
    case original, urgency, blue, purple, night, launched
    
    var label: String {
        return self.rawValue.capitalized
    }
    
    var imageName: String {
        switch self {
        case .original, .urgency, .blue, .purple: return self.rawValue
        case .night: return "dark"
        case .launched: return "blueprint"
        }
    }
}
