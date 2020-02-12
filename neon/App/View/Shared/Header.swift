//
//  NewHeader.swift
//  neon
//
//  Created by James Saeed on 11/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct Header<Content>: View where Content: View {

    let title: String
    let subtitle: String
    let content: () -> Content
    
    init(title: String, subtitle: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle.uppercased())
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("subtitle"))
                Text(title)
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color("title"))
            }
            Spacer()
            content().padding(.trailing, 14)
        }.padding(.top, 32)
        .padding(.horizontal, 32)
    }
}
