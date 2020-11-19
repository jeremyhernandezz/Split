//
//  FourthViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/7/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class FourthViewController: UIViewController {

    //Labels for circular progress bars
    @IBOutlet weak var durationProgress: MBCircularProgressBarView!
    @IBOutlet weak var setsProgress: MBCircularProgressBarView!
    @IBOutlet weak var repsProgress: MBCircularProgressBarView!
    
    //Labels for each daily stats
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var atAGlanceLabel: UILabel!
    @IBOutlet weak var durationGoalLabel: UILabel!
    @IBOutlet weak var durationCurrentLabel: UILabel!
    @IBOutlet weak var setsGoalLabel: UILabel!
    @IBOutlet weak var setsCurrentLabel: UILabel!
    @IBOutlet weak var repsGoalLabel: UILabel!
    @IBOutlet weak var repsCurrentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Initial durationProgress value
//        self.durationProgress.value = 0
//        self.setsProgress.value = 0
//        self.repsProgress.value = 0
    }
    
    //Function that initialize and displays circular progress bars
    func createTables() {
        
        //Initial durationProgress value
       self.durationProgress.value = 0
       self.setsProgress.value = 0
       self.repsProgress.value = 0
    
        
        //Arrays to store and display the data
        var decodedArray = [Exercise]()
        
        //Reset the values
        var durationTotal = 0
        var setsTotal = 0
        var repsTotal = 0
        
        var durationGoal = 0
        var setsGoal = 0
        var repsGoal = 0
        
        
        //Decode array to get user activities
        do {
            if UserDefaults.standard.object(forKey: "items") != nil {
                if let itemsArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "items") as! Data)) as? [Exercise] {
                    decodedArray = itemsArray
                }
            }

        } catch {
            print("Couldn't read file.")
        }
        
        //Create a variable to get current day date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let defaultDate = formatter.string(from: date)
        todayLabel.text = defaultDate
        todayLabel.adjustsFontSizeToFitWidth = true
        atAGlanceLabel.adjustsFontSizeToFitWidth = true
        
        for objects in decodedArray {
            if objects.date!.isEqual(defaultDate) {
                durationTotal += objects.duration ?? 0
                setsTotal += objects.sets ?? 0
                repsTotal += objects.reps ?? 0
            }
        }
        
        //Sets the labels to the current values
        durationCurrentLabel.text = String(durationTotal)
        setsCurrentLabel.text = String(setsTotal)
        repsCurrentLabel.text = String(repsTotal)
        
        //Decode user object to get daily goals
        do {
            if UserDefaults.standard.object(forKey: "user") != nil {
                if let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "user") as! Data)) as? User {
                    let savedUser = decodedUser
                    
                    //Sets the labels to the goal value
                    durationGoalLabel.text = String(savedUser.duration!)
                    setsGoalLabel.text = String(savedUser.sets!)
                    repsGoalLabel.text = String(savedUser.reps!)
                    durationGoal = savedUser.duration!
                    setsGoal = savedUser.sets!
                    repsGoal = savedUser.reps!
                    
                }
            }

        } catch {
            print("Couldn't read file.")
        }
        
        //Animation controls
        UIView.animate(withDuration: 7.0) {
            
            if durationGoal == 0  && setsGoal == 0 && repsGoal == 0 {
                self.durationProgress.maxValue = CGFloat(0)
                self.setsProgress.maxValue = CGFloat(0)
                self.repsProgress.maxValue = CGFloat(0)

                self.durationProgress.value = CGFloat(0)
                self.setsProgress.value = CGFloat(0)
                self.repsProgress.value = CGFloat(0)
                
            } else {
                
                self.durationProgress.maxValue = CGFloat(durationGoal)
                self.setsProgress.maxValue = CGFloat(setsGoal)
                self.repsProgress.maxValue = CGFloat(repsGoal)
                
                let durationPercent = Double(durationTotal) / Double(durationGoal)
                let setsPercent = Double(setsTotal) / Double(setsGoal)
                let repsPercent = Double(repsTotal) / Double(repsGoal)
                
                self.durationProgress.value = CGFloat(durationPercent * Double(durationGoal))
                self.setsProgress.value = CGFloat(setsPercent * Double(setsGoal))
                self.repsProgress.value = CGFloat(repsPercent * Double(repsGoal))
            }
            
        }
        
        
    }
    
    //Function that overrides the viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //Initial durationProgress value
        self.durationProgress.value = 0
        self.setsProgress.value = 0
        self.repsProgress.value = 0
        createTables()
        
    }

    //Function use to disapper navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
