//
//  TextBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct TextBlockView: View {
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            Text(content)
                .font(.system(size: 17, weight: .regular, design: .default))
        }
    }
}

struct TextBlockView_Previews: PreviewProvider {
    static var previews: some View {
        TextBlockView(title: "Test", content: "Test")
    }
}
