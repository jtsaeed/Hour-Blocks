//
//  Header.swift
//  neon3
//
//  Created by James Saeed on 19/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Header<Content>: View where Content: View {

    let title: String
    let subtitle: String
    let content: () -> Content
    
    init(title: String, subtitle: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .trailing) {
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
            
            content()
        }
    }
}

struct ToDoHeader: View {
    
    @EnvironmentObject var store: ToDoItemsStore
    
    @State var title = ""
    @State var priority: ToDoPriority = .none
    
    @State var isPresented = false
    
    var addButtonDisabled: Bool
    var items: Int
    
    var body: some View {
        Header(title: "To Do List", subtitle: "\(items) \(items == 1 ? "item" : "items")") {
            if !self.addButtonDisabled {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isPresented.toggle()
                }, label: {
                    Image("add_button")
                })
                .padding(.top, 32)
                .padding(.trailing, 47)
                .sheet(isPresented: self.$isPresented, content: {
                    NewToDoItemView(isPresented: self.$isPresented, title: self.$title, priority: self.$priority)
                        .environmentObject(self.store)
                })
            }
        }
    }
}
