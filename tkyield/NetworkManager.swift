//
//  NetworkManager.swift
//  tkyield
//
//  Created by Kevin on 8/9/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
import UIKit
class NetworkManager: NSObject{
    static let sharedInstance = NetworkManager()
    let baseURL = "http://192.168.10.142:3000/api/v1/"
    let sessionsURL = "sessions/"
    let timesheetsURL = "timesheets/"
    
    
    func makeAuthRequest(email: String, password:String, completion: ((errorMessage: NetworkError) -> Void)) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + sessionsURL)!)
        request.HTTPMethod = "POST"
        let postString = "email=" + email + "&password=" + password
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var errorMessage: NetworkError = NetworkError.init(json: [:])
            
            if error == nil {
                do{
                    UserPreferences.sharedInstance.setValues(try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary)
                    if (!UserPreferences.sharedInstance.valid()){
                        errorMessage = NetworkError.init(json: try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())["error"] as! NSDictionary)
                    }
                }catch{
                    print("An error ocurred")
                }
            } else {
                errorMessage = NetworkError.init(json: ["reason":error!.localizedDescription])
            }
            dispatch_async(dispatch_get_main_queue(), {
               UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               completion(errorMessage: errorMessage)
            })
            
        }
        task.resume()
    }
    
    func makeTimesheetsOfDateRequest(date: NSDate, completion: ((errorMessage: NetworkError) -> Void)) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let getString = "?date=" + dateFormatter.stringFromDate(date)
        let request = NSMutableURLRequest(URL: NSURL(string: (baseURL + timesheetsURL + getString))!)
        request.HTTPMethod = "GET"
        request.addValue(UserPreferences.sharedInstance.access_token!, forHTTPHeaderField: "Authorization")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var errorMessage = NetworkError(json: [:])
            if error == nil {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                    TimeSheet.current_timesheets = TimeSheet.init_from_json_array(json)
                }catch{
                    print("An error ocurred")
                }
            } else {
                errorMessage = NetworkError(json: ["reason":error!.localizedDescription])
            }
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(errorMessage: errorMessage)
            })
            
        }
        task.resume()
    }
    
    func deleteTimesheet(timesheet_id: Int, completion: ((errorMessage: NetworkError) -> Void)) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSMutableURLRequest(URL: NSURL(string: (baseURL + timesheetsURL + String(timesheet_id)))!)
        request.HTTPMethod = "DELETE"
        request.addValue(UserPreferences.sharedInstance.access_token!, forHTTPHeaderField: "Authorization")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var errorMessage = NetworkError(json: [:])
            if error == nil {
                do{
                    let message = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())["message"] as! String?
                    if (message == nil){
                       errorMessage = NetworkError(json: try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())["error"] as! NSDictionary)
                    }
                }catch{
                    print("An error ocurred")
                }
            } else {
                errorMessage = NetworkError(json: ["reason":error!.localizedDescription])
            }
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(errorMessage: errorMessage)
            })
            
        }
        task.resume()
    }
    
    func toggleTimesheet(timesheet_id: Int, completion: ((timesheet: TimeSheet, errorMessage: NetworkError) -> Void)) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSMutableURLRequest(URL: NSURL(string: (baseURL + timesheetsURL + String(timesheet_id) + "/toggle"))!)
        request.HTTPMethod = "PUT"
        request.addValue(UserPreferences.sharedInstance.access_token!, forHTTPHeaderField: "Authorization")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            var errorMessage = NetworkError(json: [:])
            var timesheet = TimeSheet(json: [:])
            if error == nil {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    
                    if (json.objectForKey("error") != nil){
                        errorMessage = NetworkError(json: try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())["error"] as! NSDictionary)
                    } else {
                        timesheet = TimeSheet.init(json: json)
                    }
                }catch{
                    print("An error ocurred")
                }
            } else {
                errorMessage = NetworkError(json: ["reason":error!.localizedDescription])
            }
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(timesheet: timesheet, errorMessage: errorMessage)
            })
            
        }
        task.resume()
    }
}