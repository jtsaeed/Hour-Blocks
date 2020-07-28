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
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("primary"))
                    .frame(height: 48)
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundColor(.white)
            }
        })
    }
}
