//
//  IntentHandler.swift
//  NeonSiri
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INAddTasksIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
        guard let taskTitles = intent.taskTitles else {
            completion(INAddTasksIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let taskTitlesStrings = taskTitles.map { $0.spokenPhrase }
        let tasks = createTasks(fromTitles: taskTitlesStrings)
        
        for task in tasks {
            let toDoItem = ToDoItem(title: task.title.spokenPhrase, urgency: .whenever)
            SiriDataGateway.shared.save(toDoItem: toDoItem)
        }
        
        let response = INAddTasksIntentResponse(code: .success, userActivity: .none)
        response.modifiedTaskList = intent.targetTaskList
        response.addedTasks = tasks
        completion(response)
    }
    
    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        return taskTitles.map { taskTitle in
            return INTask(title: INSpeakableString(spokenPhrase: taskTitle),
                          status: .notCompleted,
                          taskType: .completable,
                          spatialEventTrigger: nil,
                          temporalEventTrigger: nil,
                          createdDateComponents: nil,
                          modifiedDateComponents: nil,
                          identifier: nil)
        }
    }
}
