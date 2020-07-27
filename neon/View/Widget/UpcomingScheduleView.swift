//
//  UpcomingView.swift
//  Hour Blocks
//
//  Created by James Saeed on 15/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct UpcomingScheduleView: View {
    
    let hourBlock: HourBlock
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                        startPoint: .top,
                                        endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hourBlock.hour.get12hTime())
                    .font(.system(size: 17, weight: .semibold, design: .default))
                Text(hourBlock.title!.smartCapitalization())
                    .font(.system(size: 24, weight: .medium, design: .rounded))
            }.padding(16)
            .foregroundColor(.white)
        }
    }
}

struct UpcomingScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingScheduleView(hourBlock: HourBlock(day: Date(),
                                                  hour: 19,
                                                  title: "Dinner with Bonnie"))
    }
}
