//
//  TodayTableCell.swift
//  tkyield
//
//  Created by Kevin on 8/12/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit

class TodayTableCell: UITableViewCell {
    
    var timesheet = TimeSheet(json: [:])
    var seconds = Int()
    var elapsedSeconds = Double()
    var timer: Timer?
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var currentDuration: UILabel!
    
    @IBOutlet weak var clock: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBAction func actionButton(_ sender: AnyObject) {
//        NSNotificationCenter.defaultCenter().postNotificationName("stopTasks", object: nil)
        NetworkManager.sharedInstance.toggleTimesheet(self.timesheet.id!) { (timesheet, errorMessage) in
            if (errorMessage.empty()){
//                self.timesheet = timesheet
//                print(self.timesheet.running)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                self.setUp()
            } else {
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func secondsToHoursMinutesString (_ seconds : Int) -> String {
        let (h,m) = (seconds / 3600, (seconds % 3600) / 60)
        return NSString(format: "%0.2d:%0.2d",h,m) as String
    }
    
    func setDuration() -> Void {
            seconds += 60
            statusButton.setTitle(secondsToHoursMinutesString(seconds), for: UIControlState())
    }
    
    func rotateView(_ view: UIView, duration: Double = 1, key: String) {
        if view.layer.animation(forKey: key) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            view.layer.add(rotationAnimation, forKey: key)
        }
    }
    
    func stopRotatingView(_ view: UIView, key: String) {
        if view.layer.animation(forKey: key) != nil {
            view.layer.removeAnimation(forKey: key)
        }
    }
    
    func imageTransition(_ toImage: UIImage) -> Void {
        UIView.transition(with: self.statusButton.imageView!,
                                  duration:0.5,
                                  options: UIViewAnimationOptions.beginFromCurrentState,
                                  animations: { self.statusButton.setImage(toImage, for: UIControlState()) },
                                  completion: nil)
    }
    
    func setButtonAndDuration() -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        self.statusButton.backgroundColor = UIColor.clear
        if (timesheet.running!){
            self.statusButton.backgroundColor = UIColor.init(red: 21.0/255.0, green: 126.0/255.0, blue: 251.0/255.0, alpha: 1)
            self.statusButton.setTitleColor(UIColor.white, for: UIControlState())
            let date = dateFormatter.date(from: self.timesheet.start_time!)
            let elapsedTime = Date().timeIntervalSince(date!)
            self.seconds += Int(elapsedTime)
            if (self.timer == nil || !self.timer!.isValid){
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(TodayTableCell.setDuration), userInfo: nil, repeats: true)
            }
        } else {
            elapsedSeconds = 0
            self.statusButton.backgroundColor = UIColor.white
            self.statusButton.layer.borderWidth = 1
            self.statusButton.layer.borderColor = UIColor.init(red: 21.0/255.0, green: 126.0/255.0, blue: 251.0/255.0, alpha: 1).cgColor
            self.statusButton.setTitleColor(UIColor.black, for: UIControlState())
            if ( self.timer != nil && self.timer!.isValid ){
                timer!.invalidate()
            }
        }
        statusButton.setTitle(secondsToHoursMinutesString(seconds), for: UIControlState())
        
    }
    
    func setUp() -> Void {
        self.projectName.text = self.timesheet.project_name
        self.taskName.text = self.timesheet.task_name
        self.seconds = self.timesheet.total_time!
        setButtonAndDuration()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
