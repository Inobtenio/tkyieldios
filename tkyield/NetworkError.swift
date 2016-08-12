//
//  NetworkError.swift
//  tkyield
//
//  Created by Kevin on 8/10/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
class NetworkError: NSObject{
    var error_handler: String?
    var message: String?
    var reason: String?
    var suggestion: String?
    
    init(json: NSDictionary) {
        self.error_handler = json["error_handler"] as? String
        self.message = json["message"] as? String
        self.reason = json["reason"] as? String
        self.suggestion = json["suggestion"] as? String
    }
    
    func empty() -> Bool {
        return (error_handler == nil) && (message == nil) && (reason == nil) && (suggestion == nil)
    }

}