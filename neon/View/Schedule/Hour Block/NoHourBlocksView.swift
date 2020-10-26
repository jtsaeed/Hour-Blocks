//
//  NoHourBlocksView.swift
//  Hour Blocks
//
//  Created by James Saeed on 15/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A Card based view that displays the absence of any Hour Blocks.
struct NoHourBlocksView: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: AppStrings.Schedule.HourBlock.noHourBlocksTitle,
                           subtitle: AppStrings.Schedule.HourBlock.noHourBlocksSubtitle,
                           titleColor: Color(AppStrings.Colors.text),
                           horizontalAlignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
