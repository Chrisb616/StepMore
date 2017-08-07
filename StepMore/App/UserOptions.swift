//
//  UserOptions.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/7/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

class UserOptions {
    
    //MARK: - Instance
    private init() {}
    static let instance = UserOptions()
    
    //MARK: - Tools
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Keys
    private let startOfWeekKey = "startOfWeek"
    
    //MARK: - Values
    var startOfWeek: Date.Weekday = .monday
    
    func load() {
        if let startOfWeekUserDefault = userDefaults.string(forKey: startOfWeekKey), startOfWeekUserDefault == "sunday" {
                startOfWeek = .sunday
        }
    }
    
}
