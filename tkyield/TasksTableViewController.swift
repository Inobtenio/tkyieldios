//
//  TasksTableViewController.swift
//  tkyield
//
//  Created by Kevin on 8/16/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    var timesheets = [TimeSheet]()
    let textCellIdentifier = "todayCell"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var date = NSDate()
    
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        NetworkManager.sharedInstance.makeTimesheetsOfDateRequest(self.date, completion: { (errorMessage) in
            self.activityIndicator.stopAnimating()
            self.tableView.backgroundView = nil
            if (errorMessage.empty()){
                self.timesheets = TimeSheet.current_timesheets
                self.noDataBackground()
                self.tableView.reloadData()
//                self.tableView.setContentOffset(CGPointMake(0.0, -self.tableView.contentInset.top), animated: false)
                self.getCellsData()
            } else {
                
            }
        })
        refreshControl.endRefreshing()
    }
    
    func callFillData(notification: NSNotification) -> Void {
        self.date = notification.userInfo!["date"] as! NSDate
        self.fillingDataRequest(self.date)
    }
    
    func callRefreshData(notification: NSNotification) -> Void {
        let refreshControl = UIRefreshControl()
        self.refresh(refreshControl)
    }
    
    func fillingDataRequest(date: NSDate) -> Void {
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.makeTimesheetsOfDateRequest(date, completion: { (errorMessage) in
            self.activityIndicator.stopAnimating()
            self.tableView.backgroundView = nil
            if (errorMessage.empty()){
                self.timesheets = TimeSheet.current_timesheets
                self.noDataBackground()
                self.tableView.reloadData()
//                self.tableView.setContentOffset(CGPointMake(0.0, -self.tableView.contentInset.top), animated: false)
                self.getCellsData()
            } else {
                
            }
        })
    }
    
    func removeTimesheetRequest(timesheet_id: Int) -> Void {
        NetworkManager.sharedInstance.deleteTimesheet(timesheet_id) { (errorMessage) in
            if (errorMessage.empty()){
                self.noDataBackground()
                self.getCellsData()
//                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    func noDataBackground() -> Void {
        if (self.timesheets.count == 0){
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.text = "No tasks  :/"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = noDataLabel
        }
    }
    
    func getCellsData() -> Void {
        var total = 0
        for row in 0..<tableView.numberOfRowsInSection(0){
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TodayTableCell
            total += cell.seconds
        }
        NSNotificationCenter.defaultCenter().postNotificationName("setTotal", object: nil, userInfo: ["total": total])
    }
    
    func stopAllTasks(notification: NSNotification) -> Void {
        for row in 0..<tableView.numberOfRowsInSection(0){
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TodayTableCell
            cell.timesheet.running = false
        }
        self.tableView.reloadData()
//        self.tableView.setContentOffset(CGPointMake(0.0, -self.tableView.contentInset.top), animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        fillingDataRequest(self.date)
        activityIndicator.hidesWhenStopped = true;
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TasksTableViewController.callFillData(_:)),name:"load", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TasksTableViewController.callRefreshData(_:)),name:"refresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TasksTableViewController.stopAllTasks(_:)),name:"stopTasks", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "aSegue") {
            let row = tableView.indexPathForSelectedRow?.row
            let taskViewController = (segue.destinationViewController as! TaskViewController)
            taskViewController.task = TimeSheet.current_timesheets[row!]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timesheets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodayTableCell
        cell.timesheet = timesheets[indexPath.row]
        cell.setUp()
        print(timesheets.count - indexPath.row)
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            removeTimesheetRequest(timesheets[indexPath.row].id!)
            timesheets.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
