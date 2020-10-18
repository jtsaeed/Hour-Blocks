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
    
    private let title: String
    private let subtitle: String
    
    private let titleColor: Color
    private let subtitleColor: Color
    
    private let titleOpacity: Double
    private let subtitleOpacity: Double
    
    private let horizontalAlignment: HorizontalAlignment
    
    /// Creates an instance of the CardLabels view.
    ///
    /// - Parameters:
    ///   - title: The text string for the main label on the bottom.
    ///   - subtitle: The text string for the secondary label at the top.
    ///   - titleColor: The color of the main label on the bottom. By default, this is set to the app's TextColor.
    ///   - subtitleColor: The text string for the secondary label at the top. By default, this is set to the app's TextColor.
    ///   - titleOpacity: The opacity of the main label on the bottom. By default, this is set to 90%.
    ///   - subtitleOpacity: The opacity of the secondary label at the top. By default, this is set to 40%.
    ///   - horizontalAlignment: The horizontal alignment of the card labels.
    init(title: String, subtitle: String, titleColor: Color = Color("TextColor"), subtitleColor: Color = Color("TextColor"), titleOpacity: Double = 0.9, subtitleOpacity: Double = 0.4, horizontalAlignment: HorizontalAlignment = .leading) {
        self.title = title
        self.subtitle = subtitle
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.titleOpacity = titleOpacity
        self.subtitleOpacity = subtitleOpacity
        self.horizontalAlignment = horizontalAlignment
    }
    
    /// A computed property for determining the correct TextAlignment from the HorizontalAlignment.
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
