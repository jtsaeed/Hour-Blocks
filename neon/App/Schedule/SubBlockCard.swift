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
                CardIcon(iconName: currentSubBlock.iconName)
            }.modifier(CardContentPadding())
        }.modifier(CardPadding())
        .contextMenu { SubBlockCardContextMenu(currentBlock: currentSubBlock) }
    }
}

struct SubBlockCardContextMenu: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var suggestions: SuggestionsStore
    
    @State var isRenamePresented = false
    @State var isIconPickerPresented = false
    
    let currentBlock: HourBlock
    
    var body: some View {
        VStack {
            /*
            Button(action: {
                self.rename()
            }) {
                Text("Rename")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isRenamePresented, content: {
                NewBlockView(isPresented: self.$isRenamePresented, title: self.$blocks.currentTitle, currentBlock: self.currentBlock)
                    .environmentObject(self.blocks)
                    .environmentObject(self.suggestions)
            })
            Button(action: {
                self.changeIcon()
            }) {
                Text("Change Icon")
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $isIconPickerPresented, content: {
                IconPicker(isPresented: self.$isIconPickerPresented, currentBlock: self.currentBlock)
                    .environmentObject(self.blocks)
            })
 */
            Button(action: {
                self.clear()
            }) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func rename() {
        blocks.currentTitle = currentBlock.title!
        suggestions.load(for: currentBlock.hour)
        isRenamePresented.toggle()
    }
    
    func changeIcon() {
        isIconPickerPresented.toggle()
    }
    
    func clear() {
        blocks.removeSubBlock(for: currentBlock)
    }
}

struct EmptySubBlockCard: View {
    
    @EnvironmentObject var blocksStore: HourBlocksStore
    @EnvironmentObject var suggestionsStore: SuggestionsStore
    
    @State var title = ""
    
    @State var isPresented = false
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: "Sub Block",
                            subtitle: "Add a new",
                            titleColor: Color("subtitle"))
                Spacer()
                Image("pro_add_button")
                .sheet(isPresented: $isPresented, content: {
                    if DataGateway.shared.isPro() {
                        NewBlockView(isPresented: self.$isPresented, title: self.$title, currentBlock: self.currentHourBlock, isSubBlock: true)
                        .environmentObject(self.blocksStore)
                        .environmentObject(self.suggestionsStore)
                    } else {
                        ProPurchaseView(showPurchasePro: self.$isPresented)
                    }
                    
                })
            }.modifier(CardContentPadding())
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented = true
            }
        }.modifier(CardPadding())
    }
}
