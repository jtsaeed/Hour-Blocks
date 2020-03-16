//
//  NSManagedObjectContext+Ext.swift
//  neon3
//
//  Created by James Saeed on 16/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import UIKit
import CoreData

#if os(watchOS)
import WatchKit
#endif

extension NSManagedObjectContext {
    
    static var current: NSManagedObjectContext {
        #if os(watchOS)
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        return extensionDelegate.persistentContainer.viewContext
        #else
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        #endif
    }
}
