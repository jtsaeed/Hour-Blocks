//
//  SubBlockCard.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlockCard: View {
    
    let currentHourBlock: HourBlock
    let currentSubBlock: HourBlock
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: currentSubBlock.title!, subtitle: currentHourBlock.title!)
                Spacer()
                CardIcon(iconName: currentSubBlock.domain?.iconName ?? "default")
            }.modifier(CardContentPadding())
        }.modifier(CardPadding())
        .contextMenu { SubBlockCardContextMenu(currentBlock: currentSubBlock) }
    }
}

struct SubBlockCardContextMenu: View {
    
    @EnvironmentObject var store: HourBlocksStore
    
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
        store.removeSubBlock(for: currentBlock)
    }
}

struct EmptySubBlockCard: View {
    
    @EnvironmentObject var blocksStore: HourBlocksStore
    @EnvironmentObject var suggestionsStore: SuggestionsStore
    
    @State var title = ""
    
    @State var isPresented = false
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        EmptyListCard()
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented.toggle()
            }
            .sheet(isPresented: $isPresented, content: {
                NewBlockView(isPresented: self.$isPresented, title: self.$title, currentBlock: self.currentHourBlock, isSubBlock: true)
                    .environmentObject(self.blocksStore)
                    .environmentObject(self.suggestionsStore)
            })
    }
}
