//
//  Card.swift
//  neon3
//
//  Created by James Saeed on 28/09/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Card<Content>: View where Content: View {

    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 6
    let content: () -> Content

    init(cornerRadius: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    init(shadowRadius: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.shadowRadius = shadowRadius
        self.content = content
    }
    
    init(cornerRadius: CGFloat, shadowRadius: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.content = content
    }
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color("cardBacking"))
                .shadow(color: Color(white: 0).opacity(0.1), radius: shadowRadius, x: 0, y: 2)
            content()
                .padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct EmptyListCard: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Empty",
                            subtitle: "Currently",
                            titleColor: Color("subtitle"))
                Spacer()
                Image("add_button")
            }
        }
    }
}

struct CardIcon: View {
    
    let iconName: String
    
    var body: some View {
        Image(iconName).foregroundColor(Color("cardIcon"))
    }
}