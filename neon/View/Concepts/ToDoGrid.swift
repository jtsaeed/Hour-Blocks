//
//  ToDoGrid.swift
//  Hour Blocks
//
//  Created by James Saeed on 25/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ToDoGrid: View {
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 128, maximum: 512))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(1 ..< 20) { _ in
                    Card {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HIGH PRIORITY")
                                .foregroundColor(Color("RedColor"))
                                .font(.system(size: 14, weight: .semibold, design: .default))
                            Text("Sort out Charlie's room")
                                .opacity(0.9)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                        }
                    }.frame(width: 160)
                    .onDrag { return NSItemProvider(object: "Ye ma" as NSString) }
                }
            }
        }
    }
}

struct ToDoGrid_Previews: PreviewProvider {
    static var previews: some View {
        ToDoGrid()
    }
}
