//
//  Exercise.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/6/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//
import Foundation
import UIKit

//Class created to store the exercises added by the user to the activity history
class Exercise: NSObject, NSCoding {
    
    //Attributes
    var name: String?
    var date: String?
    var duration: Int?
    var sets: Int?
    var reps:  Int?
    
    //Adopted the NSCoding protocol and implemented its two methods: init(coder) and encode(with)
    init(json: [String: Any])
    {
        self.name = json["name"] as? String
        self.date = json["date"] as? String
        self.duration = json["duration"] as? Int
        self.sets = json["sets"] as? Int
        self.reps = json["reps"] as? Int
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.duration, forKey: "duration")
        aCoder.encode(self.sets, forKey: "sets")
        aCoder.encode(self.reps, forKey: "reps")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.date = aDecoder.decodeObject(forKey: "date") as? String
        self.duration = aDecoder.decodeObject(forKey: "duration") as? Int
        self.sets = aDecoder.decodeObject(forKey: "sets") as? Int
        self.reps = aDecoder.decodeObject(forKey: "reps") as? Int
    }
    
    
}
