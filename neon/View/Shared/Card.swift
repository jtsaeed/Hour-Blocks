//
//  CardView.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct Card<Content>: View where Content: View {
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: Color(white: 0).opacity(0.1), radius: 6, x: 0, y: 3)
            content()
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 32))
        }
    }
}
