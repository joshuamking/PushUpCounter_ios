//
//  ViewController.swift
//  Sandbox
//
//  Created by Joshua King on 2/21/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ... 20 {
            var time = TimeInterval(arc4random_uniform(19999000))
            time.multiply(by: -1)
            let workoutSet = WorkoutSet()
            workoutSet.count = Int(arc4random_uniform(100))
            workoutSet.timeStamp = Date.init(timeIntervalSinceNow: time)
            workoutSet.saveToRealm()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

