//
//  WorkoutSet.swift
//  Push Up Counter
//
//  Created by Joshua King on 3/3/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import Foundation
import RealmSwift

class WorkoutSet : RealmSwift.Object {
    
    dynamic var count: Int = 0
    dynamic var dateString: String = ""
    dynamic var monthAndDayString: String = ""
    dynamic var secsSinceEpoch: TimeInterval = 0
    dynamic var timeStamp: Date = Date.init(){
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            dateString = dateFormatter.string(from: timeStamp)
            
            dateFormatter.dateFormat = "MMM d"
            monthAndDayString = dateFormatter.string(from: timeStamp)
            
            secsSinceEpoch = timeStamp.timeIntervalSince1970
        }
    };
    
    func saveToRealm(){
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self)
        }
    }
}
