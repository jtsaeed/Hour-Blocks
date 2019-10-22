//
//  Card.swift
//  neon3
//
//  Created by James Saeed on 28/09/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Card: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color("cardBacking"))
            .shadow(color: Color(white: 0).opacity(0.1), radius: 6, x: 0, y: 2)
    }
}

struct CardLabels: View {
    
    let title: String
    let subtitle: String
    
    var titleColor = Color("title")
    var alignment: HorizontalAlignment = .leading
    
    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(subtitle)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(Color("subtitle"))
            Text(title.neonCapitalisation())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(titleColor)
        }
    }
}

struct CardIcon: View {
    
    let iconName: String
    
    var body: some View {
        Image(iconName).foregroundColor(Color("cardIcon"))
    }
}
