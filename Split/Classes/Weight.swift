//
//  Weight.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/20/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import Foundation
import UIKit

//Weight class made to store the weights for the weight progress chart in the profile page
class Weight: NSObject, NSCoding {
    
    //User Attributes
    var weight: String?
    var date: String?
    
    //Adopted the NSCoding protocol and implemented its two methods: init(coder) and encode(with)
    init(json: [String: Any])
    {
        //User Attributes
        self.weight = json["weight"] as? String
        self.date = json["date"] as? String
    }
    
    func encode(with aCoder: NSCoder)
    {
        //User Attributes
        aCoder.encode(self.weight, forKey: "weight")
        aCoder.encode(self.date, forKey: "date")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.weight = aDecoder.decodeObject(forKey: "weight") as? String
        self.date = aDecoder.decodeObject(forKey: "date") as? String

    }
}
