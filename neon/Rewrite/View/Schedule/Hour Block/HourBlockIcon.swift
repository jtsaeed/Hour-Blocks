//
//  HourBlockIcon.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HourBlockIcon: View {
    
    let name: String
    
    var body: some View {
        Image(name)
            .resizable()
            .frame(width: 40, height: 40)
            .opacity(0.1)
    }
}

struct HourBlockIcon_Previews: PreviewProvider {
    static var previews: some View {
        HourBlockIcon(name: "calendar")
    }
}
