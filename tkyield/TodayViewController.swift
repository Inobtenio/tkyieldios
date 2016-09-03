//
//  TodayViewController.swift
//  tkyield
//
//  Created by Kevin on 8/10/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit
class TodayViewController: UIViewController {
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayTotal: UILabel!
    var date = NSDate()
    let dateFormatter = NSDateFormatter()
    
    func todayOrDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date) == dateFormatter.stringFromDate(NSDate()) ? "Today" : dateFormatter.stringFromDate(date)
    }
    
    func changeDate(direction: String) -> Void {
        let seconds = direction == "previous" ? -86400 : 86400
        date = date.dateByAddingTimeInterval(Double(seconds))
        self.navigationItem.title = todayOrDate(date)
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil, userInfo: ["date": date])
    }
    
    func secondsToHoursMinutesString (seconds : Int) -> String {
        let (h,m) = (seconds / 3600, (seconds % 3600) / 60)
        return NSString(format: "%0.2d:%0.2d",h,m) as String
    }
    
    func setTotal(notification: NSNotification) -> Void {
        self.todayTotal.text = secondsToHoursMinutesString(notification.userInfo!["total"] as! Int)
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        changeDate("next")
    }
    @IBAction func previousDay(sender: AnyObject) {
        changeDate("previous")
    }
    
    func goToNewTaskView() -> Void {
        print("SEGUE?")
        self.performSegueWithIdentifier("newTask", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem.init(image: UIImage.init(named: "add_blue"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(TodayViewController.goToNewTaskView))
        self.navigationItem.rightBarButtonItem = button
        dateFormatter.dateFormat = "EEEE, dd MMM"
        self.navigationItem.title = "Today"
        userName.text = UserPreferences.sharedInstance.name
        if let url = NSURL(string: "https://assets-cdn.github.com/images/modules/logos_page/Octocat.png") {
            if let data = NSData(contentsOfURL: url) {
                userProfilePic.image = UIImage(data: data)
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TodayViewController.setTotal(_:)),name:"setTotal", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}