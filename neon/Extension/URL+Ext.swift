//
//  URL+Ext.swift
//  Hour Blocks
//
//  Created by James Saeed on 10/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Foundation

public extension URL {

    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
