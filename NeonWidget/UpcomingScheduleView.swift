//
//  UpcomingView.swift
//  Hour Blocks
//
//  Created by James Saeed on 15/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct UpcomingScheduleView: View {
    
    @Environment(\.colorScheme) var colorScheme

    let hourBlock: HourBlock?
    let subBlocks: [SubBlock]?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if colorScheme == .dark {
                Color(.black)
            } else {
                LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                            startPoint: .top,
                                            endPoint: .bottom)
            }
            
            Group {
                if let hourBlock = hourBlock {
                    VStack(alignment: .leading, spacing: 4) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(hourBlock.hour == Calendar.current.component(.hour, from: Date()) ? "THIS HOUR" : hourBlock.hour.get12hTime())
                                .font(.system(size: subBlocks == nil ? 17 : 18, weight: .semibold, design: .default))
                            Text(hourBlock.title!.smartCapitalization())
                                .font(.system(size: subBlocks == nil ? 24 : 26, weight: .medium, design: .rounded))
                            
                            
                        }
                        
                        if let subBlocks = subBlocks {
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(subBlocks.count > 3 ? subBlocks.dropLast(subBlocks.count - 3) : subBlocks) { subBlock in
                                    Text("• " + subBlock.title)
                                        .font(.system(size: 15, weight: .semibold, design: .default))
                                }
                            }
                        }
                    }
                    
                    
                } else {
                    Text("Nothing scheduled today")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                }
            }.padding(16)
            .foregroundColor(.white)
        }
    }
}

struct PlaceholderUpcomingScheduleView: View {
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                        startPoint: .top,
                                        endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("7PM")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .redacted(reason: .placeholder)
                Text("Dinner with Bonnie")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .redacted(reason: .placeholder)
            }.padding(16)
            .foregroundColor(.white)
        }
    }
}

struct UpcomingScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                  hour: 19,
                                                  title: "Dinner with Bonnie",
                                                  icon: .food),
                             subBlocks: nil)
    }
}
