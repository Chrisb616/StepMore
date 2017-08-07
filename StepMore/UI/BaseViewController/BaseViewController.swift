//
//  BaseViewController.swift
//  Steps
//
//  Created by Christopher Boynton on 5/12/17.
//  Copyright © 2017 Self. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var leadingBall: UIImageView!
    @IBOutlet weak var blueBall: UIImageView!
    @IBOutlet weak var greenBall: UIImageView!
    @IBOutlet weak var trailingBall: UIImageView!
    
    @IBOutlet weak var ballContainer: UIView!
    
    static func fromNib(withSucceedingViewController succeedingViewController: UIViewController) -> BaseViewController {
        let baseViewController = BaseViewController(nibName: "BaseViewController", bundle: nil)
        baseViewController.succeedingViewController = succeedingViewController
        return baseViewController
    }

    var succeedingViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            self.start {
                
                self.present(self.succeedingViewController, animated: false, completion: nil)
            }
        }
    }
    
    func start(_ completion: @escaping ()->()) {
        
        let ballStart = leadingBall.center.y
        
        let leadingAnimation = CAKeyframeAnimation(keyPath: "position.y")
        
        leadingAnimation.duration = 1.5
        leadingAnimation.keyTimes = [
            0,
            0.05,
            0.35,
            0.6,
            0.7,
            1
        ]
        leadingAnimation.values = [
            ballStart,
            ballStart,
            ballStart - 25,
            ballStart - 30,
            ballStart + 60,
            ballStart + 60
        ]
        
        leadingBall.layer.add(leadingAnimation, forKey: "position.y")
        
        let blueAnimation = CAKeyframeAnimation(keyPath: "position.y")
        
        blueAnimation.duration = 1.5
        blueAnimation.keyTimes = [
            0,
            0.15,
            0.45,
            0.65,
            0.75,
            1
        ]
        blueAnimation.values = [
            ballStart,
            ballStart,
            ballStart - 25,
            ballStart - 30,
            ballStart + 60,
            ballStart + 60
        ]
        
        blueBall.layer.add(blueAnimation, forKey: "position.y")
        
        let greenAnimation = CAKeyframeAnimation(keyPath: "position.y")
        
        greenAnimation.duration = 1.5
        greenAnimation.keyTimes = [
            0,
            0.25,
            0.55,
            0.7,
            0.8,
            1
        ]
        greenAnimation.values = [
            ballStart,
            ballStart,
            ballStart - 25,
            ballStart - 30,
            ballStart + 60,
            ballStart + 60
        ]
        
        greenBall.layer.add(greenAnimation, forKey: "position.y")
        
        let trailingAnimation = CAKeyframeAnimation(keyPath: "position.y")
        
        trailingAnimation.duration = 1.5
        trailingAnimation.keyTimes = [
            0,
            0.35,
            0.65,
            0.75,
            0.85,
            1
        ]
        trailingAnimation.values = [
            ballStart,
            ballStart,
            ballStart - 25,
            ballStart - 30,
            ballStart + 60,
            ballStart + 60
        ]
        
        trailingBall.layer.add(trailingAnimation, forKey: "position.y")
        
        let viewFade = CAKeyframeAnimation(keyPath: "opacity")
        
        viewFade.duration = 1.5
        viewFade.keyTimes = [0,9,1]
        viewFade.values = [1,1,0]
        
        ballContainer.layer.add(viewFade, forKey: "opacity")
        
        Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) {(timer) in
            self.ballContainer.isHidden = true
            completion()
        }
    }

}
