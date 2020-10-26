//
//  NewNeonTextField.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A wrapper around the native SwiftUI TextField with Hour Blocks styling. Used for all text fields within Hour Blocks.
struct NeonTextField: View {
    
    /// Environment variable identifying the current device colour scheme between dark or light mode.
    @Environment(\.colorScheme) var colorScheme
    
    @Binding private var text: String
    
    private let onReturn: () -> Void
    
    /// Creates an instance of the NeonTextField view.
    ///
    /// - Parameters:
    ///   - text: A binding of the input text.
    ///   - onReturn: The callback function to be triggered when the user hits the return key on the keyboard. By default this is set to be empty.
    init(text: Binding<String>, onReturn: @escaping () -> Void = {}) {
        self._text = text
        self.onReturn = onReturn
    }

    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 40)
                .foregroundColor(Color(AppStrings.Colors.accent).getLightColor(darkMode: colorScheme == .dark))
                .cornerRadius(8)
            TextField(AppStrings.Global.textFieldPlaceholder, text: $text, onCommit: onReturn)
                .autocapitalization(.none)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color(AppStrings.Colors.text))
                .padding(.horizontal, 16)
        }
    }
}

struct NeonTextField_Previews: PreviewProvider {
    static var previews: some View {
        NeonTextField(text: .constant("Lecture"))
    }
}
