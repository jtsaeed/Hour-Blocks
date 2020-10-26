//
//  ActionButton.swift
//  neon
//
//  Created by James Saeed on 17/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

/// The large coloured action button used sparingly throughout Hour Blocks.
struct ActionButton: View {
    
    let title: String
    let action: () -> Void
    
    /// Creates an instance of the NeonTextField view.
    ///
    /// - Parameters:
    ///   - text: A binding of the input text.
    ///   - action: The callback function to be triggered when the user has tapped on the button.
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(AppStrings.Colors.accent))
                    .frame(height: 48)
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundColor(.white)
            }
        }
    }
}
