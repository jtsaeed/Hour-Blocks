//
//  ToDoUrgency.swift
//  Hour Blocks
//
//  Created by James Saeed on 30/10/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

enum ToDoUrgency: String, CaseIterable {
    
    case whenever, soon, urgent
    
    var color: Color {
        switch self {
        case .urgent: return Color(AppStrings.Colors.urgent)
        case .soon: return Color(AppStrings.Colors.accent)
        case .whenever: return Color(AppStrings.Colors.text)
        }
    }
}
