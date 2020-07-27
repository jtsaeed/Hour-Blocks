//
//  NeonDivider.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NeonDivider: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .foregroundColor(.black)
            .frame(height: 2)
            .opacity(0.04)
    }
}

struct NeonDivider_Previews: PreviewProvider {
    static var previews: some View {
        NeonDivider()
    }
}
