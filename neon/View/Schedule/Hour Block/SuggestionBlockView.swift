//
//  SuggestionView.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct SuggestionBlockView: View {
    
    let suggestion: Suggestion
    let onAdded: () -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: suggestion.domain.suggestionTitle.smartCapitalization(),
                           subtitle: suggestion.reason)
                Spacer()
                IconButton(iconName: "plus",
                              iconWeight: .bold,
                              action: onAdded)
            }
        }.padding(.horizontal, 24)
    }
}

struct NoSuggestionsBlockView: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("TextColor"),
                           alignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionBlockView(suggestion: Suggestion(domain: .baseball, reason: "popular", score: 0),
                            onAdded: {})
    }
}
