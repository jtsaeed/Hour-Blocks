//
//  UIDevice+Ext.swift
//  Hour Blocks
//
//  Created by James Saeed on 16/09/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// Determines whether or not the current device has a notch or not.
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
