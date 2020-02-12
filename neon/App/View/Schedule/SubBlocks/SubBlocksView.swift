//
//  SubBlocksView.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlocksView: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    let hourBlock: HourBlock
    
    var body: some View {
        List {
            if viewModel.currentSubBlocks.filter({ $0.hour == hourBlock.hour }).count > 0 {
                ForEach(viewModel.currentSubBlocks.filter({ $0.hour == hourBlock.hour })) { subBlock in
                    SubBlockCard(currentHourBlock: self.hourBlock, currentSubBlock: subBlock)
                }
            }
            EmptySubBlockCard(currentHourBlock: hourBlock)
        }.navigationBarTitle("Today at \(hourBlock.formattedTime.lowercased())")
    }
}
