//
//  NewHeaderView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// The double header view used at the top of root views within Hour Blocks.
struct HeaderView<Content>: View where Content: View {
    
    private let title: String
    private let subtitle: String
    
    private let accessory: () -> Content
    
    /// Creates an instance of the Header view.
    ///
    /// - Parameters:
    ///   - title: The text string for the main label on the bottom.
    ///   - subtitle: The text string for the secondary label at the top.
    ///   - accessory: Any header accessory views; usually an icon button.
    init(title: String, subtitle: String, @ViewBuilder accessory: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color(AppStrings.Colors.background))
                .frame(height: 96)
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(subtitle.uppercased())
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .opacity(0.5)
                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .lineLimit(1)
                }
                Spacer()
                accessory()
            }.padding(.leading, 32)
            .padding(.trailing, 56)
            .padding(.top, 16)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Schedule", subtitle: "Sat 27 Jun") {
            IconButton(iconName: AppStrings.Icons.calendar, action: { print("test") })
        }
    }
}
