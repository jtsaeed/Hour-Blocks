//
//  UtilGateway.swift
//  Hour Blocks
//
//  Created by James Saeed on 08/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

struct UtilGateway {
    
    static let shared = UtilGateway()
    
    func isSystemClock12h() -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        let dateString = formatter.string(from: Date())
        let amRange = dateString.range(of: formatter.amSymbol)
        let pmRange = dateString.range(of: formatter.pmSymbol)

        return !(pmRange == nil && amRange == nil)
    }
    
    func dayStartHour() -> Int {
        if let dayStartValue = UserDefaults.standard.value(forKey: "dayStart") as? Int {
            switch dayStartValue {
            case 0: return 0
            case 1: return 5
            case 2: return 6
            case 3: return 7
            case 4: return 8
            default: return 6
            }
        } else {
            return 6
        }
    }
}
