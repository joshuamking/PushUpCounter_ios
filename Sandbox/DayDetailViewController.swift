//
//  DayDetailViewController.swift
//  Push Up Counter
//
//  Created by Joshua King on 4/10/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import UIKit
import RealmSwift

class DayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dayText : String = ""
    var total : Int = 0
    var workoutSets : Results<WorkoutSet>!
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var tableViewForSets: UITableView!
    @IBOutlet weak var numberOfSetsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayTitle.text = dayText
        
        let realm = try! Realm()
        print("monthAndDayString = '" + dayText+"'")
        self.workoutSets = realm.objects(WorkoutSet.self).filter("monthAndDayString = '" + dayText+"'").sorted(byKeyPath: "timeStamp", ascending: false)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dayTitle.text = dateFormatter.string(from: (self.workoutSets.first?.timeStamp)!)
        
        let dateString = workoutSets.first?.dateString
        
        let values = realm.objects(WorkoutSet.self).filter("dateString = '" + dateString!+"'").filter("monthAndDayString = '" + dayText+"'").map { $0.count }
    
        for value in values {
            total += value
        }
        
        let isSetsPlural = workoutSets.count != 1
        let isTotalPlural = total != 1
        
        numberOfSetsLabel.text = "\(workoutSets.count) set\(isSetsPlural ? "s" : "") consisting of \(total) push up\(isTotalPlural ? "s" : "")"
        
        tableViewForSets.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workoutSets.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sets done on \(dayText)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        
        let workoutSet = self.workoutSets[self.workoutSets.index(self.workoutSets.startIndex, offsetBy: indexPath.row)]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        cell.textLabel?.text = dateFormatter.string(from: workoutSet.timeStamp)
        cell.detailTextLabel?.text = "\(workoutSet.count) push ups"
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
