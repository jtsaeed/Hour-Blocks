//
//  Card.swift
//  neon3
//
//  Created by James Saeed on 28/09/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Card: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color("cardBacking"))
            .shadow(color: Color(white: 0).opacity(0.1), radius: 6, x: 0, y: 2)
    }
}

struct SoftCard: View {
    
    var cornerRadius: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(Color("cardBacking"))
            .shadow(color: Color(white: 0).opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct EmptyListCard: View {
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: "Empty",
                            subtitle: "Currently",
                            titleColor: Color("subtitle"))
                Spacer()
                Image("add_button")
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct EmptyFutureCard: View {
    
    @State var isPresented = false
    
    var futureBlockAdded: (String, Int, Date) -> ()
    
    var body: some View {
        EmptyListCard()
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented.toggle()
            }
            .sheet(isPresented: $isPresented, content: {
                NewFutureBlockView(isPresented: self.$isPresented, didAddBlock: { (title, hour, date) in
                    self.futureBlockAdded(title, hour, date)
                })
            })
    }
}

struct EmptyToDoCard: View {
    
    @State var title = ""
    @State var priority: ToDoPriority = .none
    
    @State var isPresented = false
    
    var toDoItemAdded: (String, ToDoPriority) -> ()
    
    var body: some View {
        EmptyListCard()
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.isPresented.toggle()
            }
            .sheet(isPresented: $isPresented, content: {
                NewToDoItemView(isPresented: self.$isPresented, title: self.$title, priority: self.$priority, didAddToDoItem: { title, priority in
                    self.toDoItemAdded(title, priority)
                })
            })
    }
}

struct CardLabels: View {
    
    let title: String
    let subtitle: String
    
    var titleColor = Color("title")
    var alignment: HorizontalAlignment = .leading
    
    var body: some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(subtitle.uppercased())
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(Color("subtitle"))
            Text(title.smartCapitalization())
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(titleColor)
                .lineLimit(1)
        }
    }
}

struct CardIcon: View {
    
    let iconName: String
    
    var body: some View {
        Image(iconName).foregroundColor(Color("cardIcon"))
    }
}
