//
//  TimeSheet.swift
//  tkyield
//
//  Created by Kevin on 8/18/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
class TimeSheet: NSObject {
    static var current_timesheets = [TimeSheet]()
    var id: Int?
    var start_time: String?
    var stop_time: String?
    var total_time: Int?
    var running: Bool?
    var notes: String?
    var belongs_to_day: String?
    var project_name: String?
    var task_name: String?
    
    init(json: NSDictionary) {
        self.id = json["id"] as? Int
        self.start_time = json["start_time"] as? String
        self.stop_time = json["stop_time"] as? String
        self.total_time = json["total_time"] as? Int
        self.running = json["running"] as? Bool
        self.notes = json["notes"] as? String
        self.belongs_to_day = json["belongs_to_day"] as? String
        self.project_name = json["project_name"] as? String
        self.task_name = json["task_name"] as? String
    }
    
    static func init_from_json_array(_ json: NSArray) -> [TimeSheet] {
        var a = [TimeSheet]()
        for piece in json {
            let ts = TimeSheet.init(json: piece as! NSDictionary)
            a.append(ts)
        }
        return a
    }
}
