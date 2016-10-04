//
//  User.swift
//  tkyield
//
//  Created by Kevin on 8/10/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
class UserPreferences {
    var name: String?
    var profile_pic: String?
    var access_token: String?
    static var sharedInstance = UserPreferences()
    
    func setValues(_ json: NSDictionary) -> Void {
        self.name = json["name"] as? String
        self.profile_pic = json["profile_pic"] as? String
        self.access_token = json["access_token"] as? String
    }
    
    func valid() -> Bool {
        return (name != nil) && (profile_pic != nil) && (access_token != nil)
    }
}
