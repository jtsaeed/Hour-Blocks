//
//  CardLabels.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct CardLabels: View {
    
    let title: String
    let subtitle: String
    
    var titleColor = Color("title")
    var subtitleColor = Color("subtitle")
    var alignment: HorizontalAlignment = .leading
    
    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(subtitle.uppercased())
                .modifier(CardSubtitleLabel())
                .foregroundColor(subtitleColor)
            Text(title.smartCapitalization())
                .modifier(CardTitleLabel())
                .foregroundColor(titleColor)
        }
    }
}

struct CardSubtitleLabel: ViewModifier {
    
    func body(content: Content) -> some View {
        content.font(.system(size: 14, weight: .semibold, design: .default))
    }
}

struct CardTitleLabel: ViewModifier {
    
    func body(content: Content) -> some View {
        content.font(.system(size: 22, weight: .bold, design: .rounded)).lineLimit(1)
    }
}
