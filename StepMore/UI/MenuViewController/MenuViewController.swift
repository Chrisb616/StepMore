//
//  MenuViewController.swift
//  StepsMainMenuGoalCell
//
//  Created by Christopher Boynton on 5/15/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var todayCountLabel: UILabel!
    
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var thisWeekCountLabel: UILabel!
    
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var thisMonthCountLabel: UILabel!
    
    @IBOutlet weak var thisYearButton: UIButton!
    @IBOutlet weak var thisYearLabel: UILabel!
    @IBOutlet weak var thisYearCountLabel: UILabel!
    
    @IBOutlet weak var sevenDayButton: UIButton!
    @IBOutlet weak var sevenDayCountLabel: UILabel!
    
    @IBOutlet weak var thirtyDayButton: UIButton!
    @IBOutlet weak var thirtyDayCountLabel: UILabel!
    
    @IBOutlet weak var threeHundredSixtyFiveDayButton: UIButton!
    @IBOutlet weak var threeHundredSixtyFiveDayCountLabel: UILabel!
    
    @IBOutlet weak var allTimeButton: UIButton!
    @IBOutlet weak var allTimeCountLabel: UILabel!
    
    var fadeView: UIView!
    
    static var fromNib: MenuViewController {
        let vc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        formatLabels()
        formatButtons()
        
        formateFadeView()
        hideAllCountLabels()
        populateCountLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activateFadeView()
    }
    
    func formateFadeView() {
        
        fadeView = UIView()
        
        self.view.addSubview(fadeView)
        
        fadeView.frame = UIScreen.main.bounds
        fadeView.backgroundColor = UIColor.white
    }
    
    func activateFadeView() {
        UIView.animate(withDuration: 1) {
            self.fadeView.alpha = 0
        }
    }
    
    func formatLabels() {
        thisMonthLabel.text = Date().asString("MMMM")
        thisYearLabel.text = Date().asString("YYYY")
    }
    
    func formatButtons() {
        formatSingleButton(todayButton)
        formatSingleButton(thisWeekButton)
        formatSingleButton(thisMonthButton)
        formatSingleButton(thisYearButton)
        formatSingleButton(sevenDayButton)
        formatSingleButton(thirtyDayButton)
        formatSingleButton(threeHundredSixtyFiveDayButton)
        formatSingleButton(allTimeButton)
    }
    
    private func formatSingleButton(_ button: UIButton) {
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        
    }
    
    func hideAllCountLabels() {
        
        todayCountLabel.isHidden = true
        thisWeekCountLabel.isHidden = true
        thisMonthCountLabel.isHidden = true
        thisYearCountLabel.isHidden = true
        sevenDayCountLabel.isHidden = true
        thirtyDayCountLabel.isHidden = true
        threeHundredSixtyFiveDayCountLabel.isHidden = true
    }
    
    func populateCountLabels() {
        
        HealthKitManager.instance.todaySingleSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.todayCountLabel.text = sample.amount.asString
                self.todayCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.thisWeekAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.thisWeekCountLabel.text = sample.amount.asString
                self.thisWeekCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.thisMonthAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.thisMonthCountLabel.text = sample.amount.asString
                self.thisMonthCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.thisYearAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.thisYearCountLabel.text = sample.amount.asString
                self.thisYearCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.sevenDayAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.sevenDayCountLabel.text = sample.amount.asString
                self.sevenDayCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.thirtyDayAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.thirtyDayCountLabel.text = sample.amount.asString
                self.thirtyDayCountLabel.isHidden = false
            }
        }
        
        HealthKitManager.instance.threeHundredSixtyFiveDayAverageSampleQuery { (sample) in
            OperationQueue.main.addOperation {
                self.threeHundredSixtyFiveDayCountLabel.text = sample.amount.asString
                self.threeHundredSixtyFiveDayCountLabel.isHidden = false
            }
        }
        
    }
    
}

