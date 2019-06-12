//
//  IntentHandler.swift
//  neonSiri
//
//  Created by James Saeed on 12/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is INAddTasksIntent {
            return AddToDoHandler()
        }
        
        return self
    }
    
}
