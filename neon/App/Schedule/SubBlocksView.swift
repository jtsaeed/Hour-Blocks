//
//  SubBlocksView.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlocksView: View {
    
    @EnvironmentObject var store: HourBlocksStore
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        List {
            if !store.isSubBlocksEmpty(for: currentHourBlock.hour) {
                ForEach(store.subBlocks[currentHourBlock.hour]!, id: \.self) { currentSubBlock in
                    SubBlockCard(currentHourBlock: self.currentHourBlock, currentSubBlock: currentSubBlock)
                }
            }
            EmptySubBlockCard(currentHourBlock: currentHourBlock)
        }.navigationBarTitle("Today at \(currentHourBlock.formattedTime.lowercased())")
    }
}
