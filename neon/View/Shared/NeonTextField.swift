//
//  NewNeonTextField.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NeonTextField: View {
    
    @Binding var input: String
    
    var color: Color = Color("AccentColorLight")
    
    let didReturn: () -> Void

    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 40)
                .foregroundColor(color)
                .cornerRadius(8)
            TextField("Enter the title here...", text: $input, onCommit: didReturn)
                .autocapitalization(.none)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color("TextColor"))
                .padding(.horizontal, 16)
        }
    }
}

struct NeonTextField_Previews: PreviewProvider {
    static var previews: some View {
        NeonTextField(input: .constant("Lecture"), didReturn: {})
    }
}
