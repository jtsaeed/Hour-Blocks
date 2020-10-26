//
//  CardsListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 26/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct CardsListView<Content>: View where Content: View {
    
    private let content: () -> Content
    
    /// Creates an instance of the Card view.
    ///
    /// - Parameters:
    ///   - padding: The padding around the card's content. A default value is provided.
    ///   - content: The view content to be rendered on top of the card.
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                content()
            }.padding(.top, 8)
            .padding(.bottom, 24)
        }
    }
}
