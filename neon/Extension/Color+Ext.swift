//
//  Color+Ext.swift
//  Hour Blocks
//
//  Created by James Saeed on 26/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

extension Color {
    
    func getLightColor(darkMode: Bool) -> Color {
        var hue: CGFloat = 0
        UIColor(self).getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        
        return Color(hue: Double(hue), saturation: darkMode ? 1.0 : 0.03, brightness: darkMode ? 0.10 : 0.97)
    }
}
