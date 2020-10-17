//
//  TipCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 14/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view for displaying a Tip.
struct TipCardView: View {
    
    private let tip: Tip
    private let onDismiss: () -> Void
    
    /// Creates an instance of WhatsNewView.
    ///
    /// - Parameters:
    ///   - tip: The instance of Tip to be displayed.
    ///   - onDismiss: The callback function to be triggered when the user dismisses the tip card.
    init(for tip: Tip, onDismiss: @escaping () -> Void) {
        self.tip = tip
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        Card {
            HStack {
                Text(tip.description)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.trailing, 16)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                IconButton(iconName: "checkmark",
                           iconWeight: .semibold,
                           iconColor: "ConfirmColor",
                           action: onDismiss)
            }
        }.padding(.horizontal, 24)
    }
}

struct TipCardView_Previews: PreviewProvider {
    static var previews: some View {
        TipCardView(for: .blockOptions, onDismiss: {})
    }
}
