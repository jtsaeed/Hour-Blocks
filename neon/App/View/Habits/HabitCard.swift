//
//  HabitCard.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HabitCard: View {
    
    @EnvironmentObject var viewModel: HabitsViewModel
    
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
    @State var isDeleteWarningPresented = false
    
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
                Text("Delete")
                Image(systemName: "trash")
            }
            .alert(isPresented: $isDeleteWarningPresented) {
                Alert(title: Text("Delete \(currentHabit.title.lowercased())"),
                      message: Text("Are you sure you'd like to delete this habit"),
                      primaryButton: .destructive(Text("Yes"), action: confirmClear),
                      secondaryButton: .cancel(Text("No, wait!")))
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
        isDeleteWarningPresented = true
    }
    
    func confirmClear() {
        HapticsGateway.shared.triggerClearBlockHaptic()
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
                CardLabels(title: "Daily Habit",
                            subtitle: "Add a new",
                            titleColor: Color("subtitle"))
                Spacer()
                Image(self.viewModel.habits.count >= 3 ? "pro_add_button" : "add_button")
                .sheet(isPresented: self.$isPresented, content: {
                    if self.viewModel.habits.count >= 3 && !DataGateway.shared.isPro() {
                        ProPurchaseView(showPurchasePro: self.$isPresented)
                    } else {
                        NewHabitView(isPresented: self.$isPresented, title: self.title) { habitTitle in
                            self.viewModel.addHabitBlock(with: habitTitle)
                        }
                    }
                })
            }
        }.onTapGesture(perform: present)
    }
    
    func present() {
        HapticsGateway.shared.triggerLightImpact()
        isPresented = true
    }
}
