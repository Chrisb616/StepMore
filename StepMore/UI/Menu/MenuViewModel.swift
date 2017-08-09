//
//  MenuViewModel.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/8/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

class MenuViewModel: ViewModel {
    
    //MARK: - Utility Properties
    var stepSampleManager = StepSampleManager.instance
    var notificationManager = NotificationManager.instance
    
    //MARK: - Stored Properties
    var todayCount: Int?
    var thisWeekCount: Int?
    var thisMonthCount: Int?
    var thisYearCount: Int?
    
    //MARK: - Reference
    var referenceName: String = "MenuViewModel"
    
    //MARK: - Initialization
    init() {
       reset()
    }
    
    //MARK: - Reset
    func reset() {
        clearValues()
        stepSampleManager.resetTodayValue()
        
        askForAllValues()
    }
    
    private func clearValues() {
        todayCount = nil
    }
    
    private func askForAllValues() {
        askForTodayCount()
    }
    
    private func askForTodayCount() {
        let key = StepSampleManager.Key.todayStepSample
        
        stepSampleManager.askForValue(for: key)
        notificationManager.addSampleQueryObserver(for: .todayStepSample, observer: self, selector: #selector(updateTodayCount))
    }
    
    //MARK: - Update Methods
    @objc func updateTodayCount(_ notification: Notification) {
        if let todaySample = notification.object as? StepSample {
            self.todayCount = todaySample.amount
            notificationManager.removeSampleQueryObserver(for: .todayStepSample, observer: self)
            notificationManager.postViewModelUpdateNotification(for: self)
        }
    }
    
}

extension MenuViewModel {
    
}
