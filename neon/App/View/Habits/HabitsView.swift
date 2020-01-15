//
//  HabitsView.swift
//  neon
//
//  Created by James Saeed on 12/01/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct HabitsView: View {
    
    @ObservedObject var viewModel = HabitsViewModel()
    
    var body: some View {
        List {
            Section(header: HabitsHeader(streaks: viewModel.habits.filter{ $0.streak > 0 }.count)) {
                ForEach(viewModel.habits) { habit in
                    HabitCard(viewModel: self.viewModel, currentHabit: habit)
                }
                EmptyHabitCard(viewModel: viewModel)
            }
        }
    }
}

private struct HabitsHeader: View {
    
    let streaks: Int
    
    var body: some View {
        Header(title: "Daily Habits",
               subtitle: "\(streaks) \(streaks == 1 ? "streak" : "streaks")") {
            EmptyView()
        }
    }
}
