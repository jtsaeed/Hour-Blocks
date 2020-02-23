//
//  TipBlockCard.swift
//  neon
//
//  Created by James Saeed on 20/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

// hold an Hour Block for options
// after they've done their first

// tap an Hour Block to view its Sub Blocks
// after they've done their 5th

struct TipBlockCard: View {
    
    @Binding var tip: Tip?
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: NSLocalizedString(self.tip?.rawValue ?? "", comment: ""),
                           subtitle: NSLocalizedString("Tip", comment: ""))
                Spacer()
                CheckButton(action: self.clearTip)
                    .padding(.leading, 8)
            }
        }
    }
    
    func clearTip() {
        HapticsGateway.shared.triggerCompletionHaptic()
        tip = nil
    }
}

enum Tip: String {
    
    case blockOptions = "tipBlockOptions"
    case swipeToChangeDay = "tipSwipeToChangeDay"
    case viewSubBlocks = "tipViewSubBlocks"
}
