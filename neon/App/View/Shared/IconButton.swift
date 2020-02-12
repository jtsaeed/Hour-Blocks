//
//  IconButton.swift
//  neon
//
//  Created by James Saeed on 11/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct IconButton: View {
    
    let iconName: String
    var pro = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(pro ? "secondaryLight" : "primaryLight"))
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(pro ? "secondary" : "primary"))
            }
        }
    }
}

