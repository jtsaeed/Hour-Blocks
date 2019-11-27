//
//  Array+Ext.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
