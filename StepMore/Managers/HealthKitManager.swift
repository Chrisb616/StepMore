//
//  HealthKitManager.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/4/17.
//  Copyright © 2017 Self. All rights reserved.
//

import HealthKit

class HealthKitManager {
    
    private init() {}
    
    static let instance = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    private let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    
    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: nil, read: Set([stepType])) { (success, error) in
            if success {
                print("SUCCESS: Health Store authorized")
            } else {
                print("FAILURE: Health Store did not authorize: \(error?.localizedDescription ?? "No error found")")
            }
        }
    }
    
    //MARK: - Main Sample Functions
    
    func allSamplesForRange(from startDate: Date, to endDate: Date, completion: @escaping ([StepSample]?, Error?)->Void) {
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
    
    func singleSampleForRange(from startDate: Date, to endDate: Date, completion: @escaping (StepSample?,Error?)->Void) {
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
    
    //MARK: - Major single sample queries
    
    func todaySingleSampleQuery(completion: @escaping (StepSample)->Void) {
        let today = Date().entireDay
        
        singleSampleForRange(from: today.start, to: today.end) { (sample, error) in
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let sample = sample else { print("ERROR: No sample for today query"); return }
            
            completion(sample)
            return
            
        }
    }
    
    //Daily Sample Queries
    
    private func dailySampleQueries(startDate: Date, endCondition: @escaping (Date)->Bool, completion: @escaping ([StepSample])->Void) {
        
        func recursion(date: Date, completion: @escaping ([StepSample])->Void) {
            singleSampleForRange(from: date.entireDay.start, to: date.entireDay.end) { (rawSample, error) in
                let sample = rawSample ?? StepSample(amount: 0, startDate: date.entireDay.start, endDate: date.entireDay.end)
                
                if endCondition(date) {
                    completion([sample])
                } else {
                    recursion(date: date.daysBefore(1), completion: { (recursionSamples) in
                        var samples = recursionSamples
                        samples.append(sample)
                        
                        completion(samples)
                    })
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
    
    
    func thisWeekDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endCondition: { (date) -> Bool in
            return date.Weekday == UserOptions.instance.startOfWeek
        }) { (samples) in
            completion(samples)
        }
    }
    
    func thisMonthDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endCondition: { (date) -> Bool in
            return date.day == 1
        }) { (samples) in
            completion(samples)
        }
    }
    
    func thisYearDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endCondition: { (date) -> Bool in
            return date.month == 1 && date.day == 1
        }) { (samples) in
            completion(samples)
        }
    }
    
    func sevenDayDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endDate: Date().daysBefore(6)) { (samples) in
            completion(samples)
        }
    }
    
    func thirtyDayDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endDate: Date().daysBefore(29)) { (samples) in
            completion(samples)
        }
    }
    
    func threeHundredSixtyFiveDayDailySampleQueries(completion: @escaping ([StepSample])->Void) {
        dailySampleQueries(startDate: Date(), endDate: Date().daysBefore(364)) { (samples) in
            completion(samples)
        }
    }
    
    //MARK: - Average Sample Queries
    
    func averageSample(samples: [StepSample]) -> StepSample {
        
        var sum = 0
        var startDate = Date()
        var endDate = Date()
        
        samples.forEach{
            sum += $0.amount
            if startDate < $0.startDate { startDate = $0.startDate }
            if endDate > $0.endDate { endDate = $0.endDate }
        }
        
        let average = sum / samples.count
        
        return StepSample(amount: average, startDate: startDate, endDate: endDate)
        
    }
    
    func thisWeekAverageSampleQuery(completion: @escaping (StepSample)->Void) {
        thisWeekDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
    
    func thisMonthAverageSampleQuery(completion: @escaping (StepSample) -> Void) {
        thisMonthDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
    
    func thisYearAverageSampleQuery(completion: @escaping (StepSample) -> Void) {
        thisYearDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
    
    func sevenDayAverageSampleQuery(completion: @escaping (StepSample) -> Void) {
        sevenDayDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
    
    func thirtyDayAverageSampleQuery(completion: @escaping (StepSample) -> Void) {
        thirtyDayDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
    
    func threeHundredSixtyFiveDayAverageSampleQuery(completion: @escaping (StepSample) -> Void) {
        threeHundredSixtyFiveDayDailySampleQueries { (samples) in
            completion(self.averageSample(samples: samples))
        }
    }
}
