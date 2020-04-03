//
//  Card.swift
//  neon3
//
//  Created by James Saeed on 28/09/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

struct Card<Content>: View where Content: View {

    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 6
    let content: () -> Content
    
    init(cornerRadius: CGFloat, shadowRadius: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.content = content
    }
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color("cardBacking"))
                .shadow(color: Color(white: 0).opacity(0.1), radius: shadowRadius, x: 0, y: 2)
            content()
                .padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

struct SwipeableHourBlockCard<Content>: View where Content: View {
    
    @Binding var offset: CGFloat
    @Binding var swiped: Bool
    
    let hourBlock: HourBlock

    let cornerRadius: CGFloat = 16
    let shadowRadius: CGFloat = 6
    
    let swipeThreshold: CGFloat = 192
    let swipedCardOffset: CGFloat = 256
    let swipedOptionsOffset: CGFloat = 28
    
    let options: () -> Content
    
    init(offset: Binding<CGFloat>, swiped: Binding<Bool>, hourBlock: HourBlock, @ViewBuilder options: @escaping () -> Content) {
        self._offset = offset
        self._swiped = swiped
        self.hourBlock = hourBlock
        self.options = options
    }

    var body: some View {
        ZStack(alignment: .trailing) {
                options()
                .opacity(Double(offset / -swipedCardOffset))
                .offset(x: -swipedOptionsOffset, y: 0)
            
            Card {
                HStack {
                    HourBlockCardLabels(currentBlock: self.hourBlock)
                    Spacer()
                    CardIcon(iconName: self.hourBlock.iconName)
                        .padding(.leading, 8)
                }
            }.offset(x: offset, y: 0)
        }.animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 1))
        .gesture(DragGesture(minimumDistance: 16, coordinateSpace: .local)
            .onChanged({ self.follow(drag: $0) })
            .onEnded({ self.resolve(drag: $0) }))
    }
    
    func follow(drag: DragGesture.Value) {
        if swiped {
            if drag.translation.width > 0 {
                offset = (drag.translation.width - swipedCardOffset)
            }
        } else {
            if drag.translation.width < 0 && drag.translation.width > -swipedCardOffset {
                offset = drag.translation.width
            }
        }
    }
    
    func resolve(drag: DragGesture.Value) {
        if swiped {
            if drag.predictedEndTranslation.width > swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = false
                withAnimation { self.offset = 0 }
            } else if drag.predictedEndTranslation.width > 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = -swipedCardOffset }
            }
        } else {
            if drag.predictedEndTranslation.width < -swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = true
                withAnimation { self.offset = -swipedCardOffset }
            } else if drag.predictedEndTranslation.width < 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = 0 }
            }
        }
    }
}

struct SwipeableSubBlockCard<Content>: View where Content: View {
    
    @Binding var offset: CGFloat
    @Binding var swiped: Bool
    
    let hourBlock: HourBlock
    let subBlock: HourBlock

    let cornerRadius: CGFloat = 16
    let shadowRadius: CGFloat = 6
    
    let swipeThreshold: CGFloat = 192
    let swipedCardOffset: CGFloat = 256
    let swipedOptionsOffset: CGFloat = 28
    
    let options: () -> Content
    
    init(offset: Binding<CGFloat>, swiped: Binding<Bool>, hourBlock: HourBlock, subBlock: HourBlock, @ViewBuilder options: @escaping () -> Content) {
        self._offset = offset
        self._swiped = swiped
        self.hourBlock = hourBlock
        self.subBlock = subBlock
        self.options = options
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            options()
            .opacity(Double(offset / -swipedCardOffset))
            .offset(x: -swipedOptionsOffset, y: 0)
            
            Card {
                HStack {
                    CardLabels(title: self.subBlock.title!,
                               subtitle: self.hourBlock.title!)
                    Spacer()
                    CardIcon(iconName: self.subBlock.iconName).padding(.leading, 8)
                }
            }.offset(x: offset, y: 0)
        }.animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 1))
        .gesture(DragGesture(minimumDistance: 16, coordinateSpace: .local)
            .onChanged({ self.follow(drag: $0) })
            .onEnded({ self.resolve(drag: $0) }))
    }
    
    func follow(drag: DragGesture.Value) {
        if swiped {
            if drag.translation.width > 0 {
                offset = (drag.translation.width - swipedCardOffset)
            }
        } else {
            if drag.translation.width < 0 && drag.translation.width > -swipedCardOffset {
                offset = drag.translation.width
            }
        }
    }
    
    func resolve(drag: DragGesture.Value) {
        if swiped {
            if drag.predictedEndTranslation.width > swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = false
                withAnimation { self.offset = 0 }
            } else if drag.predictedEndTranslation.width > 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = -swipedCardOffset }
            }
        } else {
            if drag.predictedEndTranslation.width < -swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = true
                withAnimation { self.offset = -swipedCardOffset }
            } else if drag.predictedEndTranslation.width < 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = 0 }
            }
        }
    }
}

struct SwipeableToDoCard<Content>: View where Content: View {
    
    @Binding var offset: CGFloat
    @Binding var swiped: Bool
    
    let toDoItem: ToDoItem

    let cornerRadius: CGFloat = 16
    let shadowRadius: CGFloat = 6
    
    let swipeThreshold: CGFloat = 192
    let swipedCardOffset: CGFloat = 256
    let swipedOptionsOffset: CGFloat = 28
    
    let options: () -> Content
    
    init(offset: Binding<CGFloat>, swiped: Binding<Bool>, toDoItem: ToDoItem, @ViewBuilder options: @escaping () -> Content) {
        self._offset = offset
        self._swiped = swiped
        self.toDoItem = toDoItem
        self.options = options
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            options()
            .opacity(Double(offset / -swipedCardOffset))
            .offset(x: -swipedOptionsOffset, y: 0)
            
            Card {
                CardLabels(title: self.toDoItem.title,
                subtitle: NSLocalizedString(self.toDoItem.urgency.rawValue, comment: "").uppercased(),
                subtitleColor: Color(self.toDoItem.urgency.rawValue.urgencyToColorString()),
                alignment: .center)
            }.offset(x: offset, y: 0)
        }.animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 1))
        .gesture(DragGesture(minimumDistance: 16, coordinateSpace: .local)
            .onChanged({ self.follow(drag: $0) })
            .onEnded({ self.resolve(drag: $0) }))
    }
    
    func follow(drag: DragGesture.Value) {
        if swiped {
            if drag.translation.width > 0 {
                offset = (drag.translation.width - swipedCardOffset)
            }
        } else {
            if drag.translation.width < 0 && drag.translation.width > -swipedCardOffset {
                offset = drag.translation.width
            }
        }
    }
    
    func resolve(drag: DragGesture.Value) {
        if swiped {
            if drag.predictedEndTranslation.width > swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = false
                withAnimation { self.offset = 0 }
            } else if drag.predictedEndTranslation.width > 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = -swipedCardOffset }
            }
        } else {
            if drag.predictedEndTranslation.width < -swipeThreshold {
                HapticsGateway.shared.triggerSuccessfulSwipeHaptic()
                swiped = true
                withAnimation { self.offset = -swipedCardOffset }
            } else if drag.predictedEndTranslation.width < 0 {
                HapticsGateway.shared.triggerFailedSwipeHaptic()
                withAnimation { self.offset = 0 }
            }
        }
    }
}

struct CardIcon: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let iconName: String
    
    var body: some View {
        Image(iconName)
            .opacity(colorScheme == .light ? 0.1 : 0.4)
    }
}
