//
//  CardLabels.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The double header labels used in Cards throughout Hour Blocks.
struct CardLabels: View {
    
    /// The text string for the main label on the bottom.
    let title: String
    /// The text string for the secondary label at the top.
    let subtitle: String
    
    /// The color of the main label on the bottom. By default, this is set to the app's TextColor.
    var titleColor = Color("TextColor")
    /// The text string for the secondary label at the top. By default, this is set to the app's TextColor.
    var subtitleColor = Color("TextColor")
    
    /// The opacity of the main label on the bottom. By default, this is set to 90%.
    var titleOpacity = 0.9
    /// The opacity of the secondary label at the top. By default, this is set to 40%.
    var subtitleOpacity = 0.4
    
    /// The horizontal alignment of the card labels
    var horizontalAlignment: HorizontalAlignment = .leading
    
    /// A computed property for determining the correct TextAlignment from the HorizontalAlignment
    private var textAlignment: TextAlignment {
        switch horizontalAlignment {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: return .leading
        }
    }
    
    var body: some View {
        VStack(alignment: horizontalAlignment, spacing: 4) {
            Text(subtitle.uppercased())
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(subtitleColor)
                .opacity(subtitleOpacity)
                .lineLimit(1)
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(titleColor)
                .opacity(titleOpacity)
                .lineLimit(2)
                .multilineTextAlignment(textAlignment)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(.trailing, horizontalAlignment == .leading ? 16 : 0)
    }
}
