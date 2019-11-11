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
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var blocks: HourBlocksStore
    @EnvironmentObject var settings: SettingsStore
    
    @State var timeFormatValue: Int
    
    var body: some View {
        NavigationView {
            List {
                OtherStuffCard(value: $timeFormatValue,
                               title: "Time Format",
                               description: "Change the time format used throughout Hour Blocks",
                               options: ["System", "12h", "24h"])
            }
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Done")
            }))
            .navigationBarTitle("Other Settings")
        }
        .accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            self.blocks.reloadTodayBlocks()
            self.save()
        }
    }
    
    func save() {
        settings.other[OtherSettingsKey.timeFormat.rawValue] = timeFormatValue
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
            VStack(alignment: .leading, spacing: 24) {
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
