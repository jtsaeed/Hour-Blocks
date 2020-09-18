//
//  RescheduleBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 25/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct RescheduleBlockView: View {
    
    @ObservedObject var viewModel: ScheduleViewModel
    
    @Binding var isPresented: Bool
    
    let hourBlock: HourBlock
    
    init(isPresented: Binding<Bool>, hourBlock: HourBlock) {
        self.viewModel = ScheduleViewModel(currentDate: hourBlock.day)
        self._isPresented = isPresented
        self.hourBlock = hourBlock
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= (viewModel.currentDate.isToday ?  viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { hourBlockViewModel in
                        if hourBlockViewModel.hourBlock.hour == hourBlock.hour {
                            CompactHourBlockView(viewModel: hourBlockViewModel)
                        } else {
                            RescheduleBlockCardView(viewModel: hourBlockViewModel,
                                                    hourBlock: hourBlock,
                                                    onReschedule: { self.reschedule($0, $1, $2) })
                        }
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationTitle("Reschedule Block")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }

    func reschedule(_ rescheduledBlock: HourBlock, _ replacedBlock: HourBlock, _ swappedBlock: HourBlock?) {
        viewModel.rescheduleBlock(originalBlock: hourBlock,
                                  rescheduledBlock: rescheduledBlock,
                                  replacedBlock: replacedBlock,
                                  swappedBlock: swappedBlock)
        
        NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
        
        dismiss()
    }

    func dismiss() {
        isPresented = false
    }
}

private struct RescheduleBlockCardView: View {
    
    @ObservedObject var viewModel: HourBlockViewModel
    
    let hourBlock: HourBlock
    let onReschedule: (HourBlock, HourBlock, HourBlock?) -> Void
    
    var body: some View {
        Card {
            HStack {
                CardLabels(title: viewModel.getTitle(),
                           subtitle: viewModel.getFormattedTime(),
                           titleOpacity: viewModel.getTitle() == "Empty" ? 0.4 : 0.9)
                Spacer()
                HStack(spacing: 12) {
                    if viewModel.hourBlock.title != nil {
                        IconButton(iconName: "arrow.up.arrow.down",
                                   iconWeight: .medium,
                                   action: swap)
                    }
                    IconButton(iconName: hourBlock.hour < viewModel.hourBlock.hour ? "arrow.turn.left.down" : "arrow.turn.left.up",
                               iconWeight: .medium,
                               action: attemptToReschedule)
                }
            }
        }.padding(.horizontal, 24)
        
        .alert(isPresented: $viewModel.isReplaceBlockWarningPresented) {
            Alert(title: Text("Overwrite Existing Hour Block"),
                  message: Text("Are you sure you would like to overwrite an existing Hour Block? This will also clear any Sub Blocks within the Hour Block"),
                  primaryButton: .destructive(Text("Overwrite"), action: reschedule),
                  secondaryButton: .cancel())
        }
    }
    
    func attemptToReschedule() {
        if viewModel.hourBlock.title == nil {
            reschedule()
        } else {
            viewModel.presentReplaceBlockWarning()
        }
    }
    
    func reschedule() {
        self.onReschedule(getRescheduledBlock(), viewModel.hourBlock, nil)
    }
    
    func swap() {
        let swappedBlock = HourBlock(id: viewModel.hourBlock.id,
                                     day: hourBlock.day,
                                     hour: hourBlock.hour,
                                     title: viewModel.hourBlock.title,
                                     icon: viewModel.hourBlock.icon)
        
        self.onReschedule(getRescheduledBlock(), viewModel.hourBlock, swappedBlock)
    }
    
    private func getRescheduledBlock() -> HourBlock {
        return HourBlock(id: hourBlock.id,
                         day: viewModel.hourBlock.day,
                         hour: viewModel.hourBlock.hour,
                         title: hourBlock.title,
                         icon: hourBlock.icon)
    }
}

struct RescheduleBlockView_Previews: PreviewProvider {
    static var previews: some View {
        RescheduleBlockView(isPresented: .constant(true), hourBlock: HourBlock(day: Date(), hour: 19, title: "Dinner"))
    }
}
