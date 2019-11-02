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
    
    var didRemoveBlock: () -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: currentBlock.title!,
                           subtitle: currentBlock.day.getFormattedDate())
                Spacer()
                CardIcon(iconName: currentBlock.domain?.iconName ?? "default")
                    .contextMenu {
                        Button(action: {
                            // TODO: Rename
                        }) {
                            Text("Rename")
                            Image(systemName: "pencil")
                        }
                        Button(action: {
                            self.didRemoveBlock()
                        }) {
                            Text("Clear")
                            Image(systemName: "trash")
                        }
                    }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}
