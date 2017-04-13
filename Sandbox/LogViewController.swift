//
//  LogViewController.swift
//  Push Up Counter
//
//  Created by Joshua King on 3/9/17.
//  Copyright © 2017 Joshua King. All rights reserved.
//

import UIKit
import RealmSwift

class LogViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageTitles : Array<String> = []
    var count = 0
    let pagerControl = UIPageControl()
//    var workoutSets : Results<WorkoutSet>!
    
    var pageViewController : UIPageViewController!
    
    @IBAction func swipeLeft(sender: AnyObject) {
        NSLog("SWipe left")
    }
    @IBAction func swiped(sender: AnyObject) {
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    func reset() {        
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
    
        let realm = try! Realm()
        let months = (realm.objects(WorkoutSet.self).sorted(byKeyPath: "secsSinceEpoch", ascending: false).value(forKey: "dateString") as! [String])
        
        for month in months {
            if(!pageTitles.contains(month)) {
                pageTitles.insert(month, at: pageTitles.count)
            }
        }
        
        self.count = pageTitles.count
        
        let pageContentViewController = self.viewControllerAtIndex(index: 0)!
        self.pageViewController.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.pagerControl.numberOfPages = self.count
        self.view.addSubview(pagerControl)
        
//        NSLog(self.workoutSets.first?.timeStamp.value(forKey: "month") as! String)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(index: 0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
            var index = (viewController as! MonthTableViewController).pageIndex!
            index += 1
            if(index >= self.count){
                return nil
            }
            return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
            var index = (viewController as! MonthTableViewController).pageIndex!
            if(index <= 0){
                return nil
            }
            index -= 1
            return self.viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.count == 0) || (index >= self.count)) {
            return nil
        }
        self.pagerControl.currentPage = index + 1
        self.pagerControl.updateCurrentPageDisplay()
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MonthTableViewIdentifier") as! MonthTableViewController
        
        pageContentViewController.titleText = self.pageTitles[self.pageTitles.index(self.pageTitles.startIndex, offsetBy: index)]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
