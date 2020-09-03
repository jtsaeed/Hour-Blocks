//
//  NeonDivider.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NeonDivider: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .foregroundColor(Color("TextColor"))
            .frame(height: 2)
            .opacity(colorScheme == .light ? 0.04 : 0.12)
    }
}

struct NeonDivider_Previews: PreviewProvider {
    static var previews: some View {
        NeonDivider()
    }
}
