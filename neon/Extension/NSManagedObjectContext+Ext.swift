//
//  NSManagedObjectContext+Ext.swift
//  neon
//
//  Created by James Saeed on 04/04/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//


import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
