//
//  CompactHourBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 27/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct CompactHourBlockView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    var body: some View {
        Card {
            VStack(spacing: 20) {
                HStack {
                    CardLabels(title: viewModel.title.smartCapitalization(),
                               subtitle: viewModel.time)
                    Spacer()
                    HourBlockIcon(name: viewModel.getIconName())
                }
            }
        }.padding(.horizontal, 24)
    }
}
