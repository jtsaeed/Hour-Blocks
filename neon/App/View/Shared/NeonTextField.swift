//
//  NeonTextField.swift
//  neon
//
//  Created by James Saeed on 13/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NeonTextField: View {
    
    @Binding var title: String
    
    var color: Color = Color("primaryLight")
    
    var didReturn: () -> ()

    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 44)
                .foregroundColor(color)
                .cornerRadius(8)
            TextField("Enter the title here...", text: $title, onCommit: didReturn)
                .autocapitalization(.none)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color("title"))
                .padding(.horizontal, 16)
        }.padding(24)
    }
}
