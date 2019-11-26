//
//  FutureCard.swift
//  neon3
//
//  Created by James Saeed on 03/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct FutureCard: View {
    
    let currentBlock: HourBlock
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: currentBlock.title!,
                           subtitle: currentBlock.day.getFormattedDate())
                Spacer()
                if currentBlock.domain != DomainsGateway.shared.domains["calendar"] {
                    CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
                        .contextMenu { FutureCardContextMenu(currentBlock: currentBlock) }
                } else {
                    CardIcon(iconName: "calendar")
                }
            }.modifier(CardContentPadding())
        }.modifier(CardPadding())
    }
}

struct FutureCardContextMenu: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            Button(action: {
                self.clear()
            }) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func clear() {
        blocks.removeFutureBlock(for: currentBlock)
    }
}
