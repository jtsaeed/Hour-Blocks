//
//  NewBlockView.swift
//  neon3
//
//  Created by James Saeed on 23/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import StoreKit

// MARK: - New Block View

struct NewBlockView: View {
    
    @EnvironmentObject var viewModel: ScheduleViewModel
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    
    let currentBlock: HourBlock
    var isSubBlock: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title,
                              color: isSubBlock ? Color("secondaryLight") : Color("primaryLight"),
                              didReturn: { self.addBlock(isSuggestion: false) })
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    if suggestionsViewModel.list.count > 0 {
                        ForEach(suggestionsViewModel.list, id: \.self) { suggestion in
                            SuggestionCard(suggestion: suggestion, didAddBlock: { title in
                                self.title = suggestion.title
                                self.addBlock(isSuggestion: true)
                            })
                        }
                    } else {
                        NoSuggestionsCard()
                    }
                }
                Spacer()
            }
            .navigationBarTitle(currentBlock.formattedTime.lowercased())
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                self.addBlock(isSuggestion: false)
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color(isSubBlock ? "secondary" : "primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addBlock(isSuggestion: Bool) {
        if self.title.isEmpty && !isSuggestion {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            AnalyticsGateway.shared.logHourBlock(for: DomainsGateway.shared.determineDomain(for: title)?.rawValue ?? "default",
                                                 at: currentBlock.formattedTime,
                                                 isSuggestion: isSuggestion.description)
            if isSubBlock {
                viewModel.add(hourBlock: currentBlock)
//                viewModel.addSubBlock(for: currentBlock.hour, with: title)
            } else {
//                viewModel.setTodayBlock(for: currentBlock.hour, with: title)
            }
            
            isPresented = false
            
            handleReviewRequest()
        }
    }
    
    func handleReviewRequest() {
        if DataGateway.shared.getTotalBlockCount() == 10 {
            SKStoreReviewController.requestReview()
        }
    }
}

struct SuggestionCard: View {
    
    let suggestion: Suggestion
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: self.suggestion.title,
                           subtitle: self.suggestion.reason.uppercased())
                Spacer()
                IconButton(iconName: "add_icon", action: self.add)
            }
        }
    }
    
    func add() {
        didAddBlock(suggestion.title)
    }
}

struct NoSuggestionsCard: View {
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("subtitle"),
                           alignment: .center)
            }
        }
    }
}

// MARK: New To Do

struct NewToDoView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State var title = ""
    @State var urgency: ToDoUrgency = .whenever
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title, didReturn: { })
                Text("Urgency")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                Picker("", selection: $urgency) {
                    Text("Whenever").tag(ToDoUrgency.whenever)
                    Text("Soon").tag(ToDoUrgency.soon)
                    Text("Urgent").tag(ToDoUrgency.urgent)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                Spacer()
            }
            .navigationBarTitle("Add a new to do")
            .navigationBarItems(leading: Button(action: dismiss, label: {
                Text("Cancel")
            }), trailing: Button(action: addToDo, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addToDo() {
        if title.isEmpty {
            HapticsGateway.shared.triggerErrorHaptic()
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            AnalyticsGateway.shared.logToDo()
            viewModel.addToDoItem(with: title, urgency)
            
            dismiss()
        }
    }
    
    func dismiss() {
        isPresented = false
    }
}

// MARK: New Habit

struct NewHabitView: View {
    
    @Binding var isPresented: Bool
    
    @State var title: String
    
    var didAddHabit: (String) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NeonTextField(title: $title, didReturn: addHabit)
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    SuggestionCard(suggestion: Suggestion(title: "Meditate", reason: "Popular"), didAddBlock: { title in
                        self.title = title
                        self.addHabit()
                    })
                    SuggestionCard(suggestion: Suggestion(title: "Exercise", reason: "Popular"), didAddBlock: { title in
                        self.title = title
                        self.addHabit()
                    })
                    SuggestionCard(suggestion: Suggestion(title: "Drink Water", reason: "Popular"), didAddBlock: { title in
                        self.title = title
                        self.addHabit()
                    })
                    SuggestionCard(suggestion: Suggestion(title: "Read", reason: "Popular"), didAddBlock: { title in
                        self.title = title
                        self.addHabit()
                    })
                }
                Spacer()
            }
            .navigationBarTitle("Add a new habit")
            .navigationBarItems(leading: Button(action: closeSheet, label: {
                Text("Cancel")
            }), trailing: Button(action: addHabit, label: {
                Text("Add")
            }))
            
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addHabit() {
        if self.title.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            self.isPresented = false
            self.didAddHabit(self.title)
        }
    }
    
    func closeSheet() {
        isPresented = false
    }
}
