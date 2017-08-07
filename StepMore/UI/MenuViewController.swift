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
    
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var thisYearButton: UIButton!
    @IBOutlet weak var thisYearLabel: UILabel!
    
    @IBOutlet weak var sevenDayButton: UIButton!
    @IBOutlet weak var thirtyDayButton: UIButton!
    @IBOutlet weak var threeHundredSixtyFiveDayButton: UIButton!
    @IBOutlet weak var allTimeButton: UIButton!
    
    @IBOutlet weak var testTextView: UITextView!
    
    var goals = [Goal]()
    
    static var initFromNib: MenuViewController {
        let vc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        formatLabels()
        formatButtons()
        
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
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuGoalTableViewCell.reuseId) as! MenuGoalTableViewCell
        
        let goal = goals[indexPath.row]
        
        cell.goalNameLabel.text = goal.name
        cell.goalAmountLabel.text = "\(goal.percentage.asPercentage(withDecimalPlaces: 1)) of \(goal.goalAmount.withCommas) step goal"
        cell.currentAmountLabel.text = "\(goal.currentAmount.withCommas)"
        
        return cell
    }
    
}
