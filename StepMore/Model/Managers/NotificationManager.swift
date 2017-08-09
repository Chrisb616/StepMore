//
//  NotificationManager.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/9/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

class NotificationManager {
    
    private init() {}
    static let instance = NotificationManager()
    
    func addSampleQueryObserver(for key: StepSampleManager.Key, observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: key.notificationName, object: nil)
    }
    
    func removeSampleQueryObserver(for key: StepSampleManager.Key, observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: key.notificationName, object: nil)
    }
    
    func postSampleQueryNotification(for key: StepSampleManager.Key, sample: StepSample) {
        NotificationCenter.default.post(name: key.notificationName, object: sample)
    }
    
    func addViewModelUpdateObserver(for viewModel: ViewModel, observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: viewModel.notificationName, object: nil)
    }
    
    func postViewModelUpdateNotification(for viewModel: ViewModel) {
        NotificationCenter.default.post(name: viewModel.notificationName, object: nil)
    }
}
