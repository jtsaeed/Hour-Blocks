//
//  IconPicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct IconPicker: View {
    
    @Binding var selection: SelectableIcon
    
    let columns = [
        GridItem(.adaptive(minimum: 72, maximum: 128))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(SelectableIcon.allCases, id: \.self) { icon in
                SelectableIconView(icon: icon,
                                   selected: icon == selection,
                                   onSelect: { self.select(icon) })
            }
        }.padding(.horizontal, 16)
    }
    
    func select(_ icon: SelectableIcon) {
        HapticsGateway.shared.triggerSoftImpact()
        withAnimation { self.selection = icon }
    }
}

private struct SelectableIconView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let icon: SelectableIcon
    let selected: Bool
    
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color("BackgroundColor"))
                    .shadow(color: Color(white: 0).opacity(0.1), radius: 4, x: 0, y: 2)
                    .frame(width: 64, height: 64)
                Image(icon.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: selected ? 36 : 32, height: selected ? 36 : 32)
                    .foregroundColor(Color("TextColor"))
                    .opacity(selected ? 0.6 : 0.25)
            }
            
            Text(icon.rawValue)
                .lineLimit(1)
                .font(.system(size: 12, weight: .medium))
                .opacity(0.5)
        }.onTapGesture(perform: onSelect)
    }
}

struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        IconPicker(selection: .constant(.blocks))
    }
}
