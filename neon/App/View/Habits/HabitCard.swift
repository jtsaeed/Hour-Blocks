//
//  HabitCard.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HabitCard: View {
    
    @ObservedObject var viewModel: HabitsViewModel
    
    let currentHabit: HabitBlock
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.currentHabit.title,
                           subtitle: self.currentHabit.streakDescription)
                Spacer()
                if self.currentHabit.completedToday {
                    Image("completed_tick")
                } else {
                    CardIcon(iconName: DomainsGateway.shared.determineDomain(for: self.currentHabit.title)?.iconName ?? "default")
                }
            }
        }.contextMenu { HabitCardContextMenu(viewModel: self.viewModel, currentHabit: self.currentHabit) }
    }
}

struct HabitCardContextMenu: View {
    
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var viewModel: HabitsViewModel
    
    let currentHabit: HabitBlock
    
    @State var isAddToBlockPresented = false
    
    var body: some View {
        VStack {
            if !currentHabit.completedToday {
                Button(action: complete) {
                    Text("Complete")
                    Image(systemName: "checkmark.circle")
                }
                Button(action: addToBlock) {
                    Text("Add to Block")
                    Image(systemName: "plus")
                }
                .sheet(isPresented: self.$isAddToBlockPresented, content: {
                    AddToBlockSheet(isPresented: self.$isAddToBlockPresented, title: self.currentHabit.title)
                        .environmentObject(self.scheduleViewModel)
                })
            }
            Button(action: clear) {
                Text("Clear")
                Image(systemName: "trash")
            }
        }
    }
    
    func addToBlock() {
        isAddToBlockPresented = true
    }
    
    func complete() {
        HapticsGateway.shared.triggerCompletionHaptic()
        AnalyticsGateway.shared.logHabitCompleted(for: currentHabit.title)
        viewModel.completeHabitBlock(habitBlock: currentHabit)
    }
    
    func clear() {
        viewModel.removeHabitBlock(habitBlock: currentHabit)
    }
}

struct EmptyHabitCard: View {
    
    @ObservedObject var viewModel: HabitsViewModel
    
    @State var title = ""
    
    @State var isPresented = false
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "Habit",
                            subtitle: "Add a new",
                            titleColor: Color("subtitle"))
                Spacer()
                Image("add_button")
                .sheet(isPresented: self.$isPresented, content: {
                    NewHabitView(isPresented: self.$isPresented, title: self.title) { habitTitle in
                        self.viewModel.addHabitBlock(with: habitTitle)
                    }
                })
            }
        }.onTapGesture(perform: present)
    }
    
    func present() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isPresented = true
    }
}
