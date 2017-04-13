//
//  MonthTableViewController.swift
//  Push Up Counter
//
//  Created by Joshua King on 4/9/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import UIKit
import RealmSwift

class MonthTableViewController : UITableViewController {
    
    var pageIndex : Int!
    var titleText : String!
    var workoutSets : Results<WorkoutSet>!
    var uniqueDays : Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        print("dateString = '" + titleText+"'")
        self.workoutSets = realm.objects(WorkoutSet.self).filter("dateString = '" + titleText+"'").sorted(byKeyPath: "timeStamp")
        
        let days = (self.workoutSets.sorted(byKeyPath: "secsSinceEpoch", ascending: false).value(forKey: "monthAndDayString") as! [String])
        
        for day in days {
            if(!uniqueDays.contains(day)) {
                uniqueDays.insert(day, at: uniqueDays.count)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uniqueDays.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleText
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayReusableCell", for: indexPath)
        
        let rowDateText = self.uniqueDays[self.uniqueDays.index(self.uniqueDays.startIndex, offsetBy: indexPath.row)]
    
        let realm = try! Realm()
        let values = realm.objects(WorkoutSet.self).filter("dateString = '" + titleText+"'").filter("monthAndDayString = '" + rowDateText+"'").map { $0.count }
        
        var total = 0;
        for value in values {
            total += value
        }
        
        cell.textLabel?.text = rowDateText
        cell.detailTextLabel?.text = "\(total) push ups"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        
        let dayDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "dayDetail") as! DayDetailViewController
        
        dayDetailViewController.dayText = self.uniqueDays[self.uniqueDays.index(self.uniqueDays.startIndex, offsetBy: row)]
        
        self.navigationController?.pushViewController(dayDetailViewController, animated: true)
        
    }

}
