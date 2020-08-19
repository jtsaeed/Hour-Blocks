//
//  TipCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 14/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct TipCardView: View {
    
    let tip: Tip
    let onDismiss: () -> Void
    
    var body: some View {
        Card {
            HStack {
                Text(tip.description)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.trailing, 16)
                Spacer()
                IconButton(iconName: "checkmark",
                           iconWeight: .semibold,
                           iconColor: "GreenColor",
                           action: onDismiss)
            }
        }.padding(.horizontal, 24)
    }
}

enum Tip: CustomStringConvertible {
    
    case blockOptions
    case headerSwipe
    
    case toDoSiri
    
    var description: String {
        switch self {
        case .blockOptions: return "Hold down a block for more options"
        case .headerSwipe: return "Swipe across the header to change days"
            
        case .toDoSiri: return "Ask Siri to add an item in Hour Blocks"
        }
    }
}

struct TipCardView_Previews: PreviewProvider {
    static var previews: some View {
        TipCardView(tip: .blockOptions, onDismiss: {})
    }
}
