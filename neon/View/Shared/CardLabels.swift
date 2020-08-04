//
//  CardLabels.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct CardLabels: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let subtitle: String
    
    var titleColor = Color("TextColor")
    var subtitleColor = Color("TextColor")
    
    var titleOpacity = 0.9
    var subtitleOpacity = 0.4
    
    var alignment: HorizontalAlignment = .leading
    
    var textAlignment: TextAlignment {
        if alignment == .trailing {
            return .trailing
        } else if alignment == .center {
            return .center
        }
        
        return .leading
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(subtitle.uppercased())
                .modifier(CardSubtitleFont())
                .foregroundColor(subtitleColor)
                .opacity(subtitleOpacity)
            Text(title)
                .modifier(CardTitleFont())
                .foregroundColor(titleColor)
                .opacity(titleOpacity)
                .multilineTextAlignment(textAlignment)
                .padding(.trailing, 12)
        }
    }
}

struct CardSubtitleFont: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .semibold, design: .default))
            .lineLimit(1)
    }
}

struct CardTitleFont: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .lineLimit(2)
    }
}


