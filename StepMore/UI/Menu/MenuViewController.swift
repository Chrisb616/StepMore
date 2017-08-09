//
//  MenuViewController.swift
//  StepsMainMenuGoalCell
//
//  Created by Christopher Boynton on 5/15/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //MARK: - Outlets
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
    
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: - Other UI Properties
    var fadeView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - ViewModel
    var viewModel: MenuViewModel
    
    //MARK: - Initialization
    static var fromNib: MenuViewController {
        let vc = MenuViewController.init(nibName: "MenuViewController", bundle: nil)
        
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = MenuViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatLabels()
        formatButtons()
        formatFadeView()
        
        NotificationManager.instance.addViewModelUpdateObserver(for: viewModel, observer: self, selector: #selector(update))
        viewModel.reset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activateFadeView()
    }
    
    //MARK: View Formatting
    func formatFadeView() {
        
        fadeView = UIView()
        
        self.view.addSubview(fadeView)
        
        fadeView.frame = UIScreen.main.bounds
        fadeView.backgroundColor = UIColor.white
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
    
    //MARK: Notification Set up
    
    func activateFadeView() {
        UIView.animate(withDuration: 1) {
            self.fadeView.alpha = 0
        }
    }
    
    @objc private func update(_ sender: Any) {
        OperationQueue.main.addOperation {
            if let todayCount = self.viewModel.todayCount {
                self.todayCountLabel.text = todayCount.asString
            }
        }
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
    
}

