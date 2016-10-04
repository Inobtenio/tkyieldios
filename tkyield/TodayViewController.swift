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
    var date = Date()
    let dateFormatter = DateFormatter()
    
    func todayOrDate(_ date: Date) -> String {
        return dateFormatter.string(from: date) == dateFormatter.string(from: Date()) ? "Today" : dateFormatter.string(from: date)
    }
    
    func changeDate(_ direction: String) -> Void {
        let seconds = direction == "previous" ? -86400 : 86400
        date = date.addingTimeInterval(Double(seconds))
        self.navigationItem.title = todayOrDate(date)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil, userInfo: ["date": date])
    }
    
    func secondsToHoursMinutesString (_ seconds : Int) -> String {
        let (h,m) = (seconds / 3600, (seconds % 3600) / 60)
        return NSString(format: "%0.2d:%0.2d",h,m) as String
    }
    
    func setTotal(_ notification: Notification) -> Void {
        self.todayTotal.text = secondsToHoursMinutesString((notification as NSNotification).userInfo!["total"] as! Int)
    }
    
    @IBAction func nextDay(_ sender: AnyObject) {
        changeDate("next")
    }
    @IBAction func previousDay(_ sender: AnyObject) {
        changeDate("previous")
    }
    
    func goToNewTaskView() -> Void {
        print("SEGUE?")
        self.performSegue(withIdentifier: "newTask", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem.init(image: UIImage.init(named: "add_blue"), style: UIBarButtonItemStyle.done, target: self, action: #selector(TodayViewController.goToNewTaskView))
        self.navigationItem.rightBarButtonItem = button
        dateFormatter.dateFormat = "EEEE, dd MMM"
        self.navigationItem.title = "Today"
        userName.text = UserPreferences.sharedInstance.name
        if let url = URL(string: "https://assets-cdn.github.com/images/modules/logos_page/Octocat.png") {
            if let data = try? Data(contentsOf: url) {
                userProfilePic.image = UIImage(data: data)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(TodayViewController.setTotal(_:)),name:NSNotification.Name(rawValue: "setTotal"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
