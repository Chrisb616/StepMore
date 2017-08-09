//
//  ViewModel.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/9/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

protocol ViewModel {
    
    var referenceName: String { get set }
    
}

extension ViewModel {
    
    var notificationName: Notification.Name { return Notification.Name("View Model: \(referenceName)")}
    
}
