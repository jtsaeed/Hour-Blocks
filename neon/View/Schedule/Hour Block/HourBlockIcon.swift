//
//  HourBlockIcon.swift
//  Hour Blocks
//
//  Created by James Saeed on 06/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The large material icon used on the right-hand side of Hour Block cards.
struct HourBlockIcon: View {
    
    private let name: String
    
    /// Creates an instance of the HourBlockIcon view.
    ///
    /// - Parameters:
    ///   - name: The name of the icon to be displayed.
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        Image(name)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(Color("HourBlockIconColor"))
    }
}

struct HourBlockIcon_Previews: PreviewProvider {
    static var previews: some View {
        HourBlockIcon("calendar")
    }
}

