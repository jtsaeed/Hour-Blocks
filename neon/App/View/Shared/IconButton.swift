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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("primaryLight"))
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("primary"))
            }
        }
    }
}

struct SwipeOption: View {
    
    let iconName: String
    let primaryColor: Color
    let secondaryColor: Color
    var weight: Font.Weight = .medium
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(secondaryColor)
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: weight, design: .rounded))
                    .foregroundColor(primaryColor)
            }
        }
    }
}

struct CheckButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("greenLight"))
                Image("check")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("green"))
            }
        }
    }
}

struct IconToggle: View {
    
    @Binding var enabled: Bool
    
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(enabled ? "greenLight" : "urgentLight"))
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(enabled ? "green" : "urgent"))
            }
        }
    }
}

struct IconToggle_Previews : PreviewProvider {
    static var previews: some View {
        IconToggle(enabled: .constant(false), iconName: "calendar_item", action: { })
    }
}
