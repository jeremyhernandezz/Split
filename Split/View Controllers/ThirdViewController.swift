//
//  ThirdViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 6/25/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    //Outleats
    @IBOutlet weak var resultsTableView: UITableView!
    
    //Arrays to store and display the data
    var decodedArray = [Exercise]()
    var uniqueSections = Set<String>()
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set nav bar edit button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(ClearTapped))

        //Created tableView
        createSections()
    }
    
    //Function to initialize sections and rows of the array
    func createSections() {
        
        //Resetted the values
        var decodedArray = [Exercise]()
        uniqueSections = Set<String>()
        sections = [Section]()
        
        //Checks whether or not the persisted array is empty
        do {
            if UserDefaults.standard.object(forKey: "items") != nil {
                if var itemsArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "items") as! Data)) as? [Exercise] {
                    
                    //Testing the ordered activities
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"

                    //Order the dates on asceding order
                    itemsArray = itemsArray.sorted(by: { dateFormatter.date(from: $0.date!)!.compare(dateFormatter.date(from: $1.date!)!) == .orderedAscending })
                    
                    //Makes sure first value is displayed in the graph
                    let firstExercise: Exercise = itemsArray[0]
                    decodedArray.append(firstExercise)
                    
                    //Copies the objects decoded into decodedArray
                    for object in itemsArray {
                        decodedArray.append(object)
                    }
                    
                }
            }
        } catch {
            print("Couldn't decode data.")
        }
        
        //Variables to iterate throught array
        let a = 0
        let b = a + 1
        
        //Checks if the date is the same to add the exercises to the same day
        for i in a..<decodedArray.count {
            
            //Bool to store if the date was already covered
            var dateAlreadyExist: Bool = false
            
            //Check if the current date already exist
            for objects in sections {
                
                //Checks if the dates are the same
                if decodedArray[i].date!.isEqual(objects.date) {
                    dateAlreadyExist = true
                }
            }
            
            //Skip to the next exercise object since this date was already covered
            if dateAlreadyExist {
                continue
            }
            
            //Temporary array to store exercises that where added on the same day
            var tempSameDay = [Exercise]()
            
            for j in b..<decodedArray.count {
                if decodedArray[i].date!.isEqual(decodedArray[j].date!) {
                    tempSameDay.append(decodedArray[j])
                }
            }
            let tempSection = Section(date: decodedArray[i].date!, exercises: tempSameDay, expanded: false)
            sections.append(tempSection)
        }
            
    }
    
    //Function that is called everytime the view controller is selected. This function updates the table with any new entries.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Recalled the function to initialize the table
        createSections()
        //print("This was called")
        resultsTableView.reloadData()
        
    }
    
    //MARK: -- TableView functions
    
    //Returns the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    //Require functions to initialize the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].exercises.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            //Shows row
            return 55
        } else {
            //Hides row
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].date, section: section, delegate: self)
        return header
    }
    
    //Function returns the name of the exercise
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        
        //cell.setsLabel = "ehllo"
        var setsTemp = String (sections[indexPath.section].exercises[indexPath.row].sets!)
        var repsTemp = String (sections[indexPath.section].exercises[indexPath.row].reps!)
        
        //Created to compensate for not setwidth() function in swift
        while (setsTemp.count <= 6) {
            setsTemp.append("  ")
        }
        
        while (repsTemp.count <= 6) {
            repsTemp.append("  ")
        }
        cell.textLabel?.textColor = UIColor.systemGreen
        cell.textLabel?.text = sections[indexPath.section].exercises[indexPath.row].name
        cell.detailTextLabel?.text = "Sets: \(setsTemp)      Reps: \(repsTemp)       Duration: \(sections[indexPath.section].exercises[indexPath.row].duration!) mins"
        return cell
    }
    
    //Function implements the expanding and collapsing feature
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        sections[section].expanded = !sections[section].expanded
        resultsTableView.beginUpdates()
        
        for i in 0 ..< sections[section].exercises.count {
            resultsTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        
        resultsTableView.endUpdates()
    }
    
    //Clear the registed exercises
    @objc func ClearTapped(sender: UIBarButtonItem) {
        
        //Prints alert to screen to verify if user wishes to log out and delete account
            let alert = UIAlertController(title: "Do you want to clear all current registed exercises?", message: "This will delete all your exercise informtion", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //Deletes activity history
                UserDefaults.standard.removeObject(forKey: "items")
                
                //performs segue to initial view controller
                //self.performSegue(withIdentifier: "unwindToInitialViewController", sender: self)
                self.viewWillAppear(true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
    }
}

