//
//  NeonDivider.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// An adaptation of the native SwiftUI Divider with Hour Blocks styling. Used to seperate groups of Card based views.
struct NeonDivider: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .foregroundColor(Color(AppStrings.Colors.divider))
            .frame(height: 2)
    }
}

struct NeonDivider_Previews: PreviewProvider {
    static var previews: some View {
        NeonDivider()
    }
}
