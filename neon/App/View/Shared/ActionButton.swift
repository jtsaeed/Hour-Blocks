//
//  ActionButton.swift
//  neon
//
//  Created by James Saeed on 17/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct ActionButton: View {
    
    let title: String
    var color: Color = Color("primary")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(color)
                .frame(height: 48)
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .default))
                .foregroundColor(.white)
        }
    }
}

struct SecondaryActionButton: View {
    
    let title: String
    var color: Color = Color("primary")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.clear)
                .frame(height: 48)
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .default))
                .foregroundColor(color)
        }
    }
}
