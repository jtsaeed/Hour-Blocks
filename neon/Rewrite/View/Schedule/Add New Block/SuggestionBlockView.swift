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
        NewCard {
            HStack {
                NewCardLabels(title: suggestion.title,
                              subtitle: suggestion.reason)
                Spacer()
                NewIconButton(iconName: "plus",
                              iconWeight: .bold,
                              action: onAdded)
            }
        }.padding(.horizontal, 24)
    }
}

struct NoSuggestionsBlockView: View {
    
    var body: some View {
        NewCard {
            HStack {
                NewCardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("subtitle"),
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
