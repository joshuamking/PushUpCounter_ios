//
//  ViewController.swift
//  Sandbox
//
//  Created by Joshua King on 2/21/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import UIKit
import RealmSwift

class CounterViewController: UIViewController {
    
    var count = 0;
    var lastPushUpTimeStamp = Double(0);
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func onMainViewClicked(_ sender: UITapGestureRecognizer) {
        increaseCount();
    }
    
    @IBAction func onDoneButtonClicked(_ sender: UIBarButtonItem) {
        if(count == 0){
            back()
        } else {
            // create the alert
            let alert = UIAlertController(title: "Are you really done?", message: "You completed " + String.init(count) + " pushup" + (count == 1 ? "" : "s"), preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in
                
                self.save();
                self.back()
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func save(){
        let workoutSet = WorkoutSet()
        workoutSet.count = count;
        workoutSet.timeStamp = Date.init();
        workoutSet.saveToRealm();
    }
    
    func back (){
        _ = navigationController?.popViewController(animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func increaseCount(){
        let now = NSDate().timeIntervalSince1970
        if(now - lastPushUpTimeStamp >= 0.25){
            lastPushUpTimeStamp = NSDate().timeIntervalSince1970
            count += 1;
            countLabel.text = String.init(count)
        }
    }
}

