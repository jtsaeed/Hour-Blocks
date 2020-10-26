//
//  SuggestionView.swift
//  Hour BlocksTests
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view for displaying a suggested Hour Block.
struct SuggestionBlockView: View {
    
    private let suggestion: Suggestion
    private let onSuggestionAdded: () -> Void
    
    /// Creates an instance of SuggestionBlockView.
    ///
    /// - Parameters:
    ///   - suggestion: The suggestion to display.
    ///   - onSuggestionAdded: The callback function to be triggered when the user chooses to add the suggested Hour Block.
    init(for suggestion: Suggestion, onSuggestionAdded: @escaping () -> Void) {
        self.suggestion = suggestion
        self.onSuggestionAdded = onSuggestionAdded
    }
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: suggestion.domain.suggestionTitle.smartCapitalization(),
                           subtitle: suggestion.reason)
                Spacer()
                IconButton(iconName: AppStrings.Icons.add,
                              iconWeight: .bold,
                              action: onSuggestionAdded)
            }
        }.padding(.horizontal, 24)
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionBlockView(for: Suggestion(domain: .baseball, reason: "popular", score: 0),
                            onSuggestionAdded: {})
    }
}
