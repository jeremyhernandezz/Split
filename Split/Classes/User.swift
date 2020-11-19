//
//  User.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/16/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import Foundation
import UIKit

//Class to store the user information
class User: NSObject, NSCoding {
    
    //User Attributes
    var firstName: String?
    var lastName: String?
    var gender: String?
    var age: Int?
    var height: String?
    // User Goals
    var duration: Int?
    var sets: Int?
    var reps:  Int?
    
    //Adopted the NSCoding protocol and implemented its two methods: init(coder) and encode(with)
    init(json: [String: Any])
    {
        //User Attributes
        self.firstName = json["firstName"] as? String
        self.lastName = json["lastName"] as? String
        self.gender = json["gender"] as? String
        self.age = json["age"] as? Int
        self.height = json["height"] as? String
        //Goals
        self.duration = json["duration"] as? Int
        self.sets = json["sets"] as? Int
        self.reps = json["reps"] as? Int
    }
    
    func encode(with aCoder: NSCoder)
    {
        //User Attributes
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.height, forKey: "height")
        //Goals
        aCoder.encode(self.duration, forKey: "duration")
        aCoder.encode(self.sets, forKey: "sets")
        aCoder.encode(self.reps, forKey: "reps")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.age = aDecoder.decodeObject(forKey: "age") as? Int
        self.height = aDecoder.decodeObject(forKey: "height") as? String
        self.duration = aDecoder.decodeObject(forKey: "duration") as? Int
        self.sets = aDecoder.decodeObject(forKey: "sets") as? Int
        self.reps = aDecoder.decodeObject(forKey: "reps") as? Int
    }
}
