//
//  IconPicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 09/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A grid view of selectable icons.
struct IconPicker: View {
    
    @Binding private var currentSelection: SelectableIcon
    
    /// Creates an instance of the IconPicker view.
    ///
    /// - Parameters:
    ///   - currentSelection: A binding of the current selected icon.
    init(currentSelection: Binding<SelectableIcon>) {
        self._currentSelection = currentSelection
    }
    
    var body: some View {
        LazyVGrid(columns: [ GridItem(.adaptive(minimum: 72, maximum: 128)) ], spacing: 24) {
            ForEach(SelectableIcon.allCases, id: \.self) { icon in
                SelectableIconTile(icon,
                                   selected: icon == currentSelection,
                                   onSelect: { select(icon) })
            }
        }.padding(.horizontal, 16)
    }
    
    /// Sets the current selection to the selected icon.
    ///
    /// - Parameters:
    ///   - icon: The selected icon.
    func select(_ icon: SelectableIcon) {
        HapticsGateway.shared.triggerSoftImpact()
        withAnimation { currentSelection = icon }
    }
}

/// A tile view for a selectable icon.
private struct SelectableIconTile: View {
    
    private let icon: SelectableIcon
    private let selected: Bool
    private let onSelect: () -> Void
    
    
    /// Creates an instance of an IconPicker view.
    ///
    /// - Parameters:
    ///   - icon: The icon to be dispalyed in the tile.
    ///   - selected: The value to determine whether or not to show the tile in the selected state.
    ///   - onSelect: The callback function to be triggered when the user has tapped on the button.
    init(_ icon: SelectableIcon, selected: Bool, onSelect: @escaping () -> Void) {
        self.icon = icon
        self.selected = selected
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(AppStrings.Colors.background))
                    .shadow(color: Color(white: 0).opacity(0.1), radius: 4, x: 0, y: 2)
                    .frame(width: 64, height: 64)
                Image(icon.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: selected ? 36 : 32, height: selected ? 36 : 32)
                    .foregroundColor(Color(AppStrings.Colors.text))
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
        IconPicker(currentSelection: .constant(.blocks))
    }
}
