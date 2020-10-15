//
//  Tip.swift
//  Hour Blocks
//
//  Created by James Saeed on 14/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

enum Tip: CustomStringConvertible {
    
    case blockOptions
    case headerSwipe
    
    case toDoSiri
    
    var description: String {
        switch self {
        case .blockOptions: return "Hold down on a block for more options"
        case .headerSwipe: return "Swipe across the header to change days"
            
        case .toDoSiri: return "Ask Siri to add an item in Hour Blocks"
        }
    }
}
