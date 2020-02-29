//
//  IconPicker.swift
//  neon
//
//  Created by James Saeed on 26/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct IconPicker: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    let currentBlock: HourBlock
    
    let icons = [
        "Creative": ["brush", "create", "music_note", "palette"],
        "Social": ["call", "group", "local_bar", "local_cafe", "nature_people", "restaurant", "shopping_cart", "theaters"],
        "Sports": ["emoji_events", "fitness_center", "golf_course", "pool", "sports_baseball", "sports_basketball",
                    "sports_cricket", "sports_hockey", "sports_rugby", "sports_soccer", "sports_tennis", "sports_volleyball"],
        "Travel": ["commute", "directions_bus", "directions_car", "directions_run", "directions_subway", "flight", "hotel"],
        "Work": ["alarm_clock", "call", "chrome_reader", "code", "create", "email", "group", "school", "work"],
        "Other": ["home", "how_to_vote", "local_florist", "local_laundry", "tv", "waves", "wb_sunny"]
    ]
    
    var body: some View {
        NavigationView {
            IconChoiceList(isPresented: $isPresented,
                           currentBlock: currentBlock,
                           icons: icons)
            .navigationBarTitle("Choose an icon")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color("primary"))
    }
}

private struct IconChoiceList: View {
    
    @Binding var isPresented: Bool
    
    let currentBlock: HourBlock
    let icons: [String: [String]]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Creative", comment: ""),
                                  iconNames: icons["Creative"]!)
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Social", comment: ""),
                                  iconNames: icons["Social"]!)
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Sports", comment: ""),
                                  iconNames: icons["Sports"]!)
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Travel", comment: ""),
                                  iconNames: icons["Travel"]!)
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Work", comment: ""),
                                  iconNames: icons["Work"]!)
                IconChoiceSection(isPresented: $isPresented,
                                  currentBlock: currentBlock,
                                  sectionTitle: NSLocalizedString("Other", comment: ""),
                                  iconNames: icons["Other"]!)
            }.padding(.vertical, 24)
        }.padding(.leading, 16)
    }
}

private struct IconChoiceSection: View {
    
    @Binding var isPresented: Bool
    
    let currentBlock: HourBlock
    let sectionTitle: String
    let iconNames: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sectionTitle.uppercased())
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(Color("subtitle"))
                .padding(.leading, 8)
            IconChoiceRow(isPresented: $isPresented,
                          currentBlock: currentBlock,
                          iconNames: iconNames)
        }
    }
}

private struct IconChoiceRow: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    let currentBlock: HourBlock
    let iconNames: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(iconNames, id: \.self) { iconName in
                    IconChoice(iconName: iconName)
                    .onTapGesture {
                        self.save(with: iconName)
                    }
                }
            }.padding(8)
        }
    }
    
    func save(with newIconName: String) {
        HapticsGateway.shared.triggerLightImpact()
        viewModel.editBlockIcon(for: currentBlock, iconOverride: newIconName)
        isPresented = false
    }
}

private struct IconChoice: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let iconName: String
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("cardBacking"))
                .shadow(color: Color(white: 0).opacity(0.1), radius: 4, x: 0, y: 2)
                .frame(width: 64, height: 64)
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .opacity(colorScheme == .light ? 0.25 : 0.6)
        }
    }
}
