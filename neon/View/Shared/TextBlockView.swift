//
//  TextBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 11/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view that contains a title text view above a multiline content text view.
struct TextBlockView: View {
    
    private let title: String
    private let content: String
    
    
    /// Creates an instance of TextBlockView.
    ///
    /// - Parameters:
    ///   - title: The text string for the main label at the top.
    ///   - content: The text string for the secondary content on the bottom.
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
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
