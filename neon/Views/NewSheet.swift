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
    
    @EnvironmentObject var blocksStore: HourBlocksStore
    @EnvironmentObject var suggestionsStore: SuggestionsStore
    
    @Binding var isPresented: Bool
    @Binding var title: String
    
    let currentBlock: HourBlock
    var isSubBlock: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NewTextField(title: $title, color: isSubBlock ? Color("secondaryLight") : Color("primaryLight") ,didReturn: { title in
                    self.addBlock(isSuggestion: false)
                })
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    if suggestionsStore.list.count > 0 {
                        ForEach(suggestionsStore.list, id: \.self) { suggestion in
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
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            AnalyticsGateway.shared.logHourBlock(for: DomainsGateway.shared.determineDomain(for: title)?.key ?? "default",
                                                 at: currentBlock.formattedTime,
                                                 isSuggestion: isSuggestion.description)
            if isSubBlock {
                blocksStore.addSubBlock(for: currentBlock.hour, with: title)
            } else {
                blocksStore.setTodayBlock(for: currentBlock.hour, with: title)
            }
            
            isPresented = false
            title = ""
            
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
        ZStack {
            Card()
            HStack {
                CardLabels(title: suggestion.title,
                           subtitle: suggestion.reason.uppercased())
                Spacer()
                Image("add_button")
                .onTapGesture {
                    self.didAddBlock(self.suggestion.title)
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct NoSuggestionsCard: View {
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: "None",
                           subtitle: "Currently",
                           titleColor: Color("subtitle"),
                           alignment: .center)
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

// MARK: New Habit

struct NewHabitView: View {
    
    @Binding var isPresented: Bool
    
    @State var title: String
    
    var didAddHabit: (String) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NewTextField(title: $title, didReturn: { title in
                    if self.title.isEmpty {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    } else {
                        self.isPresented = false
                        self.didAddHabit(self.title)
                    }
                })
                Spacer()
            }
            .navigationBarTitle("Add a new habit")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    self.isPresented = false
                    self.didAddHabit(self.title)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: New To Do Item View

struct NewToDoItemView: View {
    
    @EnvironmentObject var store: ToDoItemsStore
    
    @Binding var isPresented: Bool
    
    @Binding var title: String
    @Binding var priority: ToDoPriority
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NewTextField(title: $title, didReturn: { title in })
                Picker("Set a priority", selection: $priority) {
                    Text(ToDoPriority.high.rawValue).tag(ToDoPriority.high)
                    Text(ToDoPriority.medium.rawValue).tag(ToDoPriority.medium)
                    Text(ToDoPriority.low.rawValue).tag(ToDoPriority.low)
                    Text(ToDoPriority.none.rawValue).tag(ToDoPriority.none)
                }.labelsHidden()
                Spacer()
            }
            .navigationBarTitle("What's on your list?")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                self.addToDoItem()
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addToDoItem() {
        if self.title.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } else {
            HapticsGateway.shared.triggerAddBlockHaptic()
            AnalyticsGateway.shared.logToDo()
            store.addToDoItem(with: title, priority)
            
            isPresented = false
            title = ""
        }
    }
}

struct NewTextField: View {
    
    @Binding var title: String
    
    var color: Color = Color("primaryLight")
    
    var didReturn: (String) -> ()

    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 44)
                .foregroundColor(color)
                .cornerRadius(8)
            TextField("Enter the title here...", text: $title) {
                self.didReturn(self.title)
            }
                .autocapitalization(.none)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color("title"))
                .padding(.horizontal, 16)
        }.padding(24)
    }
}
