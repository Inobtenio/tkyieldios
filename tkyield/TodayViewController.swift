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
    
    func UITableView_Auto_Height()
    {
        if(self.tableView.contentSize.height < self.tableView.frame.height){
            var frame: CGRect = self.tableView.frame;
            frame.size.height = self.tableView.contentSize.height;
            self.tableView.frame = frame;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TODAY VIEW CONTROLLER")
        UITableView_Auto_Height()
        userName.text = UserPreferences.sharedInstance.name
        if let url = NSURL(string: "https://assets-cdn.github.com/images/modules/logos_page/Octocat.png") {
            if let data = NSData(contentsOfURL: url) {
                userProfilePic.image = UIImage(data: data)
            }        
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}