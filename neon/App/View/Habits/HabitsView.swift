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
            Section(header: HabitsHeader()) {
                if !viewModel.habits.isEmpty {
                    ForEach(viewModel.habits, id: \.self) { habit in
                        HabitCard(viewModel: self.viewModel, currentHabit: habit)
                    }
                }
                EmptyHabitCard(viewModel: viewModel)
            }
        }
    }
}

private struct HabitsHeader: View {
    
    var body: some View {
        Header(title: "Habits", subtitle: "Habits") {
            EmptyView()
        }
    }
}
