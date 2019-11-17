//
//  HabitsView.swift
//  neon
//
//  Created by James Saeed on 17/11/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct HabitsView: View {

    @ObservedObject var store = HabitBlocksStore()
    
    var body: some View {
        List {
            Section(header: HabitsHeader(addButtonDisabled: store.habits.isEmpty, didAddHabit: { title in
                self.store.addHabitBlock(with: title)
            })) {
                if (store.habits.isEmpty) {
                    EmptyHabitCard(didAddHabit: { title in
                        self.store.addHabitBlock(with: title)
                    })
                } else {
                    ForEach(store.habits, id: \.self) { habitBlock in
                        HabitCard(currentBlock: habitBlock, didRemoveHabit: {
                            self.store.removeHabitBlock(habitBlock: habitBlock)
                        })
                    }
                }
            }
        }
    }
}

struct HabitCard: View {
    
    let currentBlock: HabitBlock
    
    var didRemoveHabit: () -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: currentBlock.title,
                           subtitle: currentBlock.streakDescription)
                Spacer()
                CardIcon(iconName: DomainsGateway.shared.determineDomain(for: currentBlock.title)?.iconName ?? "default")
                    .contextMenu {
                        Button(action: {
                            self.didRemoveHabit()
                        }) {
                            Text("Clear")
                            Image(systemName: "trash")
                        }
                    }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}
