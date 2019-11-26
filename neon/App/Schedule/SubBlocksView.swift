//
//  SubBlocksView.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct SubBlocksView: View {
    
    let currentHourBlock: HourBlock
    
    var body: some View {
        NavigationView {
            Header(title: currentHourBlock.formattedTime, subtitle: Date().getFormattedDate())
        }.accentColor(Color("primary"))
    }
}
