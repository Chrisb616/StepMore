//
//  Date.swift
//  Steps
//
//  Created by Christopher Boynton on 5/19/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

typealias DateRange = (beginning: Date, end: Date)

extension Date {

    
    static func fromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-M-d-H-m-s"
        
        let dateString = "\(year) \(month) \(day) \(hour) \(minute) \(second)"
        
        return dateFormatter.date(from: dateString)
        
    }
    
    func asString(_ formatString: String) -> String? {
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = formatString
        
        return dateFormat.string(from: self)
    }
    
    
    static func weekAfter(_ date: Date) -> [Date] {
        return daysInRange(withStart: date, end: date.daysAfter(6))
    }
    
    static func weekBefore(_ date: Date) -> [Date] {
        return daysInRange(withStart: date.daysBefore(6), end: date)
    }
    
    static func daysInRange(withStart start: Date, end: Date) -> [Date] {
        
        if end.isBefore(start) { print("FAILURE: To find days in range, start must be before finish"); return [] }
        
        var range = [Date]()
        
        var date = start
        let finish = end.entireDay.end
        
        while date.isBefore(finish) {
            range.append(date)
            date = date.daysAfter(1)
        }
        
        return range
    }
    
    //MARK: - Date Ranges
    
    static func entireDay(year: Int, month: Int, day: Int) -> DateRange {
        
        guard let beginning = Date.fromComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0) else { fatalError() }
        guard let end = Date.fromComponents(year: year, month: month, day: day, hour: 23, minute: 59, second: 59) else { fatalError() }
        
        return (beginning: beginning, end: end)
        
    }
    
    var entireDay: DateRange {
        
        return Date.entireDay(year: self.year, month: self.month, day: self.day)
        
    }
    
    static func entireMonth(year: Int, month: Int) -> DateRange {
        
        guard let beginning = Date.fromComponents(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0) else { fatalError() }
        guard let end = Date.fromComponents(year: year, month: month, day: Date.daysInMonth(month, year: year), hour: 23, minute: 59, second: 59) else { fatalError() }
        
        return (beginning: beginning, end: end)
        
    }
    
    var entireMonth: DateRange {
        return Date.entireMonth(year: self.year, month: self.month)
    }
    
    func daysBetween(_ date: Date) -> Int {
        return calendar.dateComponents([.day], from: self, to: date).day!
    }
    
    func daysBefore(_ amount: Int) -> Date {
        
        var daysBefore = DateComponents()
        daysBefore.calendar = calendar
        daysBefore.day = amount * -1
        
        return calendar.date(byAdding: daysBefore, to: self)!
    }
    
    func daysAfter(_ amount: Int) -> Date {
        
        var daysAfter = DateComponents()
        daysAfter.calendar = calendar
        daysAfter.day = amount
        
        return calendar.date(byAdding: daysAfter, to: self)!
    }
    
    func isBefore(_ date: Date) -> Bool {
        
        return self.timeIntervalSince(date) < 0
        
    }
    
    //MARK: Date components
    
    private var calendar: Calendar { return Calendar.current }
    
    var year: Int {
        return calendar.dateComponents([.year], from: self).year ?? 0
    }
    var month: Int {
        return calendar.dateComponents([.month], from: self).month ?? 0
    }
    var day: Int {
        return calendar.dateComponents([.day], from: self).day ?? 0
    }
    var hour: Int {
        return calendar.dateComponents([.hour], from: self).hour ?? 0
    }
    var minute: Int {
        return calendar.dateComponents([.minute], from: self).minute ?? 0
    }
    var second: Int {
        return calendar.dateComponents([.second], from: self).second ?? 0
    }
    
    static func daysInMonth(_ month: Int, year: Int) -> Int {
        switch month {
        case 1,3,5,7,8,10,12: return 31
        case 4,6,9,11: return 30
        default:
            if year % 4 == 0 {
                if year % 100 == 0 {
                    if year % 400 == 0 {
                        return 29
                    } else {
                        return 28
                    }
                } else {
                    return 29
                }
            } else {
                return 28
            }
        }
    }
    
    var daysInMonth: Int {
        
        return Date.daysInMonth(self.month, year: self.year)
        
    }
}
