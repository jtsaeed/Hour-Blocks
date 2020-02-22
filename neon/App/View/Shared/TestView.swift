//
//  TestView.swift
//  neon
//
//  Created by James Saeed on 22/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    /*
    @State var blocks = [
        HourBlock(day: Date(), hour: 0, title: "Wake Up"),
        HourBlock(day: Date(), hour: 1, title: "Coffee"),
        HourBlock(day: Date(), hour: 2, title: "Shower"),
        HourBlock(day: Date(), hour: 3, title: "Breakfast"),
        HourBlock(day: Date(), hour: 4, title: "Commute"),
        HourBlock(day: Date(), hour: 0, title: "Lecture")
    ]
 */
    
    @Binding var blocks: [HourBlock]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks) { hourBlock in
                    HourBlockCard(hourBlock: hourBlock)
                }.onMove(perform: move)
            }.navigationBarItems(trailing: EditButton())
            .navigationBarTitle("Schedule")
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        blocks.move(fromOffsets: source, toOffset: destination)
        
//        printHourBlocks()
        
        for i in 0 ..< blocks.count {
            blocks[i].hour = i
        }
    }
    
    func printHourBlocks() {
        for hourBlock in blocks {
            print("Block: \(hourBlock.title!) at \(hourBlock.formattedTime)")
        }
    }
}
