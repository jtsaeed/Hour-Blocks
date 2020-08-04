//
//  NewHeaderView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HeaderView<Content>: View where Content: View {
    
    let title: String
    let subtitle: String
    let headerDetail: () -> Content
    
    init(title: String, subtitle: String, @ViewBuilder headerDetail: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.headerDetail = headerDetail
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color("BackgroundColor"))
                .frame(height: 96)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(subtitle.uppercased())
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .opacity(0.5)
                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .default))
                }
                Spacer()
                headerDetail()
            }.padding(.leading, 32)
            .padding(.trailing, 56)
            .padding(.top, 16)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Schedule", subtitle: "Sat 27 Jun") {
            IconButton(iconName: "calendar", action: { print("ye ma") })
        }
    }
}
