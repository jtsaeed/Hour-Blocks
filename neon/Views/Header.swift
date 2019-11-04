//
//  Header.swift
//  neon3
//
//  Created by James Saeed on 19/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Header: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subtitle.uppercased())
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(Color("subtitle"))
                .padding(.top, 8)
                .padding(.leading, 32)
            Text(title)
                .font(.system(size: 34))
                .fontWeight(.bold)
                .foregroundColor(Color("title"))
                .padding(.top, 4)
                .padding(.leading, 32)
        }
        .frame(width: UIScreen.main.bounds.width, height: 112, alignment: .leading)
        .background(Color("background"))
    }
}

struct TodayHeader: View {
    
    @Binding var allDayEvent: String
    
    var body: some View {
        Header(title: "Today", subtitle: allDayEvent != "" ? allDayEvent : Date().getFormattedDate())
    }
}

struct FutureHeader: View {
    
    @State var isPresented = false
    
    var addButtonDisabled: Bool
    
    var futureBlockAdded: (String, Date) -> ()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Header(title: "The Future", subtitle: "A week into")
        
            if !addButtonDisabled {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isPresented.toggle()
                }, label: {
                    Image("add_button")
                })
                .padding(.top, 32)
                .padding(.trailing, 47)
                .sheet(isPresented: $isPresented, content: {
                    NewFutureBlockView(isPresented: self.$isPresented, didAddBlock: { (title, date) in
                        self.futureBlockAdded(title, date)
                    })
                })
            }
        }
    }
}

struct HabitsHeader: View {
    
    @State var isPresented = false
    
    var habitAdded: (String) -> ()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Header(title: "Habits", subtitle: "Habits")
        
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented.toggle()
            }, label: {
                Image("add_button")
            })
            .padding(.top, 32)
            .padding(.trailing, 47)
            .sheet(isPresented: $isPresented, content: {
                NewFutureBlockView(isPresented: self.$isPresented, didAddBlock: { (title, date) in
                    self.habitAdded(title)
                })
            })
        }
    }
}

struct ToDoHeader: View {
    
    @State var isPresented = false
    
    var addButtonDisabled: Bool
    var items: Int
    
    var toDoItemAdded: (String, ToDoPriority) -> ()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Header(title: "To Do List", subtitle: "\(items) \(items == 1 ? "item" : "items")")
            
            if !addButtonDisabled {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isPresented.toggle()
                }, label: {
                    Image("add_button")
                })
                .padding(.top, 32)
                .padding(.trailing, 47)
                .sheet(isPresented: $isPresented, content: {
                    NewToDoItemView(isPresented: self.$isPresented, didAddToDoItem: { title, priority in
                        self.toDoItemAdded(title, priority)
                    })
                })
            }
        }
    }
}
