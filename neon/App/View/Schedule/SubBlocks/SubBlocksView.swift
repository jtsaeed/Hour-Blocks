//
//  SubBlocksView.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlocksView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        List {
            if !viewModel.isSubBlocksEmpty(for: currentHourBlock.hour) {
                ForEach(viewModel.subBlocks[currentHourBlock.hour]!, id: \.self) { currentSubBlock in
                    SubBlockCard(currentHourBlock: self.currentHourBlock, currentSubBlock: currentSubBlock)
                }
            }
            EmptySubBlockCard(currentHourBlock: currentHourBlock)
        }.navigationBarTitle("Today at \(currentHourBlock.formattedTime.lowercased())")
    }
}
