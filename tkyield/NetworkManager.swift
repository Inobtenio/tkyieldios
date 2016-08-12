//
//  NetworkManager.swift
//  tkyield
//
//  Created by Kevin on 8/9/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
class NetworkManager: NSObject{
    static let sharedInstance = NetworkManager()
    let baseURL = "http://localhost:3000/api/v1/"
    let sessionsURL = "sessions"
    
    
    func makeAuthRequest(email: String, password:String, completion: ((errorMessage: NetworkError) -> Void)) {
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
                    print(UserPreferences.sharedInstance.access_token)
                    print(UserPreferences.sharedInstance.profile_pic)
                    print(UserPreferences.sharedInstance.name)
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
               completion(errorMessage: errorMessage)
            })
            
        }
        task.resume()
    }
}