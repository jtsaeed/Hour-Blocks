//
//  CardView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct Card<Content>: View where Content: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let content: () -> Content
    var padding: EdgeInsets
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 32)
    }
    
    init(padding: EdgeInsets, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.padding = padding
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .opacity(colorScheme == .light ? 1 : 0.08)
                .shadow(color: Color(white: 0).opacity(0.1), radius: 6, x: 0, y: 3)
            content()
                .padding(padding)
        }
    }
}
