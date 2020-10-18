//
//  RescheduleBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 25/08/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view for rescheduling an pre-determined block.
struct RescheduleBlockView: View {
    
    @ObservedObject private var viewModel: ScheduleViewModel
    
    @Binding private var isPresented: Bool
    
    private let originalHourBlock: HourBlock
    
    /// Creates an instance of RescheduleBlockView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    ///   - hourBlock: The Hour Block to be rescheduled.
    init(isPresented: Binding<Bool>, hourBlock: HourBlock) {
        self.viewModel = ScheduleViewModel(currentDate: hourBlock.day)
        self._isPresented = isPresented
        self.originalHourBlock = hourBlock
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(viewModel.todaysHourBlocks.filter { $0.hourBlock.hour >= (viewModel.currentDate.isToday ?  viewModel.currentHour : UtilGateway.shared.dayStartHour()) }) { hourBlockViewModel in
                        if hourBlockViewModel.hourBlock.hour == originalHourBlock.hour {
                            CompactHourBlockView(viewModel: hourBlockViewModel)
                        } else {
                            RescheduleBlockCardView(viewModel: hourBlockViewModel,
                                                    originalHourBlock: originalHourBlock,
                                                    onReschedule: { reschedule($0, $1, $2) })
                        }
                    }
                }.padding(.top, 8)
                .padding(.bottom, 24)
            }.navigationTitle("Reschedule Block")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }.accentColor(Color("AccentColor"))
    }
    
    /// Reschedules an Hour Block to the schedule, then dismisses the view after refreshing the schedule.
    ///
    /// - Parameters:
    ///   - rescheduledBlock: The newly rescheduled Hour Block.
    ///   - replacedBlock: The Hour Block to be replaced, which may be empty.
    ///   - swappedBlock: The Hour Block being swapped, if there is one.
    private func reschedule(_ rescheduledHourBlock: HourBlock, _ replacedHourBlock: HourBlock, _ swappedHourBlock: HourBlock?) {
        viewModel.rescheduleBlock(originalBlock: originalHourBlock,
                                  rescheduledBlock: rescheduledHourBlock,
                                  replacedBlock: replacedHourBlock,
                                  swappedBlock: swappedHourBlock)
        
        NotificationCenter.default.post(name: Notification.Name("RefreshSchedule"), object: nil)
        
        dismiss()
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

/// A Card based view for displaying an Hour Block with rescheduling controls.
private struct RescheduleBlockCardView: View {
    
    @ObservedObject private var viewModel: HourBlockViewModel
    
    private let originalHourBlock: HourBlock
    private let onReschedule: (HourBlock, HourBlock, HourBlock?) -> Void
    
    /// Creates an instance of RescheduleBlockCardView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model for the potentially rescheduled Hour Block.
    ///   - originalHourBlock: The Hour Block to be rescheduled.
    ///   - onReschedule: The callback function to be triggered when the user confirms a rescheduling action.
    init(viewModel: HourBlockViewModel, originalHourBlock: HourBlock, onReschedule: @escaping (_ rescheduleHourBlock: HourBlock, _ replacedHourBlock: HourBlock, _ swappedHourBlock: HourBlock?) -> Void) {
        self.viewModel = viewModel
        self.originalHourBlock = originalHourBlock
        self.onReschedule = onReschedule
    }
    
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
                    IconButton(iconName: originalHourBlock.hour < viewModel.hourBlock.hour ? "arrow.turn.left.down" : "arrow.turn.left.up",
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
    
    /// Performs the reschedule request if the target block is empty, otherwise a warning is presented to the user to confirm the request
    private func attemptToReschedule() {
        if viewModel.hourBlock.title == nil {
            reschedule()
        } else {
            viewModel.presentReplaceBlockWarning()
        }
    }
    
    /// Performs the reschedule request.
    private func reschedule() {
        onReschedule(getRescheduledBlock(), viewModel.hourBlock, nil)
    }
    
    /// Creates the swapped block by taking the target block's properties and replacing the day and hour with that of the original block.
    /// The reschedule request is then perfromed with the swapped block.
    private func swap() {
        let swappedBlock = HourBlock(id: viewModel.hourBlock.id,
                                     day: originalHourBlock.day,
                                     hour: originalHourBlock.hour,
                                     title: viewModel.hourBlock.title,
                                     icon: viewModel.hourBlock.icon)
        
        onReschedule(getRescheduledBlock(), viewModel.hourBlock, swappedBlock)
    }
    
    /// Creates the rescheduled block by taking the original block's properties and replacing the day and hour with that of the target block.
    ///
    /// - Returns:
    /// The rescheduled block
    private func getRescheduledBlock() -> HourBlock {
        return HourBlock(id: originalHourBlock.id,
                         day: viewModel.hourBlock.day,
                         hour: viewModel.hourBlock.hour,
                         title: originalHourBlock.title,
                         icon: originalHourBlock.icon)
    }
}

struct RescheduleBlockView_Previews: PreviewProvider {
    static var previews: some View {
        RescheduleBlockView(isPresented: .constant(true), hourBlock: HourBlock(day: Date(), hour: 19, title: "Dinner"))
    }
}
