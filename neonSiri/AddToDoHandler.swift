//
//  AddToDoHandler.swift
//  neonSiri
//
//  Created by James Saeed on 12/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import Intents

class AddToDoHandler: NSObject, INAddTasksIntentHandling {
    
    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
        guard let taskTitles = intent.taskTitles else {
            completion(INAddTasksIntentResponse(code: .failure, userActivity: .none))
            return
        }
        let tasks = createTasks(fromTitles: taskTitles.map { $0.spokenPhrase })
        
        for taskTitle in taskTitles {
            let toDoItem = ToDoItem(id: nil, title: taskTitle.spokenPhrase, priority: .none)
            DataGateway.shared.saveToDo(item: toDoItem)
        }
        
        let response = INAddTasksIntentResponse(code: .success, userActivity: .none)
        response.modifiedTaskList = intent.targetTaskList
        response.addedTasks = tasks
        completion(response)
    }
    
    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        var tasks: [INTask] = []
        tasks = taskTitles.map { taskTitle -> INTask in
            let task = INTask(title: INSpeakableString(spokenPhrase: taskTitle),
                              status: .notCompleted,
                              taskType: .completable,
                              spatialEventTrigger: nil,
                              temporalEventTrigger: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
            return task
        }
        return tasks
    }
}
