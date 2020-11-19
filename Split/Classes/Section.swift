//
//  Section.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/9/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//
import Foundation

//Struct that represents the sections inside the activity history tableView 
struct Section {
    var date: String
    var exercises: [Exercise]
    var expanded: Bool
    
    init(date: String, exercises: [Exercise], expanded: Bool) {
        self.date = date
        self.exercises = exercises
        self.expanded = expanded
    }
    
}
