//
//  CardsListView.swift
//  Hour Blocks
//
//  Created by James Saeed on 26/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A scrollable view to contain a list of Card based views.
struct CardsListView<Content>: View where Content: View {
    
    private let content: () -> Content
    
    /// Creates an instance of the CardList view.
    ///
    /// - Parameters:
    ///   - content: The Cards content to be rendered within the scrollable list view.
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
