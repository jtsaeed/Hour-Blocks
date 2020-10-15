//
//  NoHourBlocksView.swift
//  Hour Blocks
//
//  Created by James Saeed on 15/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NoHourBlocksView: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Hour Blocks",
                           subtitle: "No",
                           titleColor: Color("TextColor"),
                           horizontalAlignment: .center)
            }
        }.padding(.horizontal, 24)
    }
}
