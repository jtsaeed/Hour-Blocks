//
//  OtherSettingsView.swift
//  neon
//
//  Created by James Saeed on 30/10/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import EventKit

struct OtherSettingsView: View {
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @State var scheduleBlocksStyleValue: Int
    
    var body: some View {
        NavigationView {
            List {
                OtherStuffCard(value: $scheduleBlocksStyleValue,
                               title: "Schedule Blocks Style",
                               description: "Change the way blocks are shown to you in the Schedule",
                               options: ["Hour", "Half", "Quarter"])
            }
            .navigationBarTitle("Other Settings")
        }.navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            self.save()
        }
    }
    
    func save() {
        settings.other[OtherSettingsKey.scheduleBlocksStyle.rawValue] = scheduleBlocksStyleValue
    }
}

struct OtherStuffCard: View {
    
    @Binding var value: Int
    
    let title: String
    let description: String
    let options: [String]
    
    var body: some View {
        ZStack {
            SoftCard(cornerRadius: 24)
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text(description)
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .opacity(0.45)
                }
        
                Picker("", selection: $value) {
                    ForEach(0 ..< options.count) { index in
                        Text(self.options[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }.padding(24)
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}
