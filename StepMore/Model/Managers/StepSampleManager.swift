//
//  StepSampleManager.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/9/17.
//  Copyright © 2017 Self. All rights reserved.
//

import HealthKit

class StepSampleManager {
    
    //MARK: - Instance
    static let instance = StepSampleManager()
    
    //MARK: - Utility Properties
    private let healthStore = HKHealthStore()
    private let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    private let notificationManager = NotificationManager.instance
    
    //MARK: - Samples
    private var keyedSamples = [Key:StepSample]()
    private var dailySamples = [Date:StepSample]()
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Authorization
    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: nil, read: Set([stepType])) { (success, error) in
            if success {
                print("SUCCESS: Health Store authorized")
            } else {
                print("FAILURE: Health Store did not authorize: \(error?.localizedDescription ?? "No error found")")
            }
        }
    }
    
    //MARK: - Reset
    func resetTodayValue() {
        keyedSamples[.todayStepSample] = nil
        dailySamples[Date().entireDay.start] = nil
        
        
    }
    
    //MARK: - Getters
    func askForValue(for key: Key) {
        switch key {
        case .todayStepSample:
            todaySingleStepSample(completion: { (sample) in
                //NotificationCenter.default.post(name: key.notificationName, object: sample, userInfo: nil)
                NotificationManager.instance.postSampleQueryNotification(for: key, sample: sample)
            })
        }
    }
    
    func askForValue(for date: Date) {
        let day = date.entireDay.start
        if let sample = dailySamples[day] {
            NotificationCenter.default.post(name: Notification.Name("\(date)"), object: self, userInfo: [date:sample])
        } else {
            
        }
    }
    
    //MARK: - Major Sample Functions
    private func allSamplesForRange(from startDate: Date, to endDate: Date, completion: @escaping ([StepSample]?, Error?)->Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: Int.max, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let samples = samples {
                var stepSamples = [StepSample]()
                
                for sample in samples {
                    
                    if let quantitySample = sample as? HKQuantitySample {
                        
                        let stepSample = StepSample(amount: Int(quantitySample.quantity.doubleValue(for: HKUnit.count())), startDate: quantitySample.startDate, endDate: quantitySample.endDate)
                        
                        stepSamples.append(stepSample)
                        
                    }
                }
                completion(stepSamples, error)
                
            } else {
                completion(nil, error)
            }
            
        }
        
        healthStore.execute(query)
        
    }
    
    private func singleSampleForRange(from startDate: Date, to endDate: Date, completion: @escaping (StepSample?,Error?)->Void) {
        let predicate = HKStatisticsQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, stats, error) in
            
            guard let stats = stats else {
                completion(nil, error)
                return
            }
            
            guard let quantity = stats.sumQuantity() else {
                completion(nil, error)
                return
            }
            
            let count = Int(quantity.doubleValue(for: HKUnit.count()))
            
            let sample = StepSample(amount: count, startDate: startDate, endDate: endDate)
            
            completion(sample,error)
            
        }
        
        healthStore.execute(query)
    }
    
    private func dailySampleQueries(startDate: Date, endCondition: @escaping (Date)->Bool, completion: @escaping ([StepSample])->Void) {
        
        func recursion(date: Date, completion: @escaping ([StepSample])->Void) {
            
            if let dailySample = dailySamples[date.entireDay.start] {
                if endCondition(date) {
                    completion([dailySample])
                } else {
                    recursion(date: date.daysBefore(1), completion: { (recursionSamples) in
                        var mutableSamples = recursionSamples
                        mutableSamples.append(dailySample)
                        
                        completion(mutableSamples)
                    })
                }
            } else {
                
                singleSampleForRange(from: date.entireDay.start, to: date.entireDay.end) { (rawSample, error) in
                    let sample = rawSample ?? StepSample(amount: 0, startDate: date.entireDay.start, endDate: date.entireDay.end)
                    
                    self.dailySamples.updateValue(sample, forKey: date.entireDay.start)
                    
                    if endCondition(date) {
                        completion([sample])
                    } else {
                        recursion(date: date.daysBefore(1), completion: { (recursionSamples) in
                            var mutableSamples = recursionSamples
                            mutableSamples.append(sample)
                            completion(mutableSamples)
                        })
                    }
                }
            }
        }
        
        recursion(date: startDate) { (samples) in
            completion(samples)
            
        }
    }
    
    private func dailySampleQueries(startDate: Date, endDate: Date, completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: startDate, endCondition: { (date) -> Bool in
            return date.day == endDate.day && date.month == endDate.month && date.year == endDate.year
        }) { (samples) in
            completion(samples)
        }
    }
    
    //MARK: - Specific Sample Functions
    private func todaySingleStepSample(completion: @escaping (StepSample)->Void) {
        if let keyedSample = keyedSamples[.todayStepSample] {
            dailySamples.updateValue(keyedSample, forKey: keyedSample.startDate)
            completion(keyedSample)
        } else if let dailySample = dailySamples[Date().entireDay.start] {
            keyedSamples.updateValue(dailySample, forKey: .todayStepSample)
            completion(dailySample)
        } else {
            singleSampleForRange(from: Date().entireDay.start, to: Date().entireDay.end) { (sample, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let sample = sample {
                    self.dailySamples.updateValue(sample, forKey: sample.startDate)
                    self.keyedSamples.updateValue(sample, forKey: .todayStepSample)
                    completion(sample)
                }
            }
        }
    }
}
extension StepSampleManager {
    
    enum Key {
        case todayStepSample
        
        var notificationName: Notification.Name {
            switch self {
            case .todayStepSample: return Notification.Name("Key: \(self)")
            }
        }
    }
    
}

