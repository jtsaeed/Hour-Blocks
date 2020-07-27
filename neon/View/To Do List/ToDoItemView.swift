//
//  ToDoItemCardView.swift
//  Hour Blocks
//
//  Created by James Saeed on 12/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoItemView: View {
    
    let toDoItem: ToDoItem
    
    var body: some View {
        Card {
            CardLabels(title: toDoItem.title,
                       subtitle: toDoItem.urgency.rawValue,
                       subtitleColor: Color(toDoItem.urgency.rawValue.urgencyToColorString()),
                       subtitleOpacity: 1.0,
                       alignment: .center)
        }.padding(.horizontal, 24)
    }
}

/*
struct ToDoItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemCardView()
    }
}
*/
