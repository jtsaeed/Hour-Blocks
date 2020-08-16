//
//  IconButton.swift
//  neon6
//
//  Created by James Saeed on 27/06/2020.
//

import SwiftUI

struct IconButton: View {
    
    let iconName: String
    var iconWeight: Font.Weight = .regular
    var iconColor: String = "AccentColor"
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .foregroundColor(Color("\(iconColor)Light"))
                    .frame(width: 40, height: 40)
                Image(systemName: iconName)
                    .foregroundColor(Color(iconColor))
                    .font(.system(size: 20, weight: iconWeight, design: .rounded))
            }
        })
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(iconName: "plus", action: { print("test") })
    }
}
