//
//  AddNewSubBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct ManageSubBlocksView: View {
    
    @Binding var isPresented: Bool
    let hourBlock: NewHourBlock
    let onSubBlockAdded: (SubBlock) -> Void
    
    @State var title = ""
    
    var body: some View {
        NewNeonTextField(input: $title, didReturn: addSubBlock)
            .padding(24)
    }
    
    func addSubBlock() {
        onSubBlockAdded(SubBlock(of: hourBlock, title: title))
        
        dismiss()
    }
    
    func dismiss() {
        isPresented = false
    }
}
