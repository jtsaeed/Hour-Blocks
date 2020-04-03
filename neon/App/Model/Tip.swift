//
//  Tip.swift
//  neon
//
//  Created by James Saeed on 10/03/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum Tip: String {
    
    #if targetEnvironment(macCatalyst)
    case swipeBlockOptions = "tipSwipeBlockOptionsMac"
    case blockOptions = "tipBlockOptionsMac"
    case swipeToChangeDay = "tipSwipeToChangeDayMac"
    #else
    case swipeBlockOptions = "tipSwipeBlockOptions"
    case blockOptions = "tipBlockOptions"
    case swipeToChangeDay = "tipSwipeToChangeDay"
    #endif
}
