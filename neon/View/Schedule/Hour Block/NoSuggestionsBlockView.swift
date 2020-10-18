//
//  NoSuggestionsBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 16/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view that displays the absence of any suggested Hour Blocks.
struct NoSuggestionsBlockView: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("TextColor"),
                           horizontalAlignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
