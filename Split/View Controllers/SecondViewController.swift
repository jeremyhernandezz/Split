//
//  SecondViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 6/24/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    //OutLets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    //Array for exercises
    var exerciseArray = ["Lunges", "Pushups", "Squats", "Burpees", "Situps", "Crunches", "Dumbbell rows", "Side planks", "Glute bridge", "Pullups", "Deadlifts", "Kettlebell swings", "Donkey kicks", "Triceps kickbacks", "Planks", "Pulldown", "Bench press", "Barbell curl", "Skaters", "Leg press", "Leg extension", "Dumbbell flye", "Goblet squat", "Battling ropes", "Reverse lunge", "Back squat", "Rowing", "Standing pulldown", "TRX triceps press", "Boxing", "Jogging"]
    
    //Variable to be able to search
    var filteredExercises = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sort array
        //exerciseArray.sort()
        
        //Set delegates and segues
        tblView.delegate = self
        tblView.dataSource = self
        searchBar.delegate = self
        
        filteredExercises = exerciseArray
    }
    
    
    //Identidy which segue to be working on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Passes data from current cell to new view controller
        if (tblView == self.tblView) {
            if segue.identifier == "MasterToDetail" {
                let destVC = segue.destination as! AddExerciseViewController
                //Sending the data to the VC destionation
                destVC.name = sender as? String
            }
        }
    }
    
    //MARK: -- Functions for tableView
    
    //Function to pass data to new tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = filteredExercises[indexPath.row]
        performSegue(withIdentifier: "MasterToDetail", sender: exercise)
    }
    
    //Function that defines number of rows in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //conditional for using searchBar
        if searching {
            return filteredExercises.count
        }
        else {
            return exerciseArray.count
        }
        
    }
    
    //Function that describes what happens at each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = filteredExercises[indexPath.row]
        
        //Conditional for using searchBar
        if searching {
            cell?.textLabel?.text = filteredExercises[indexPath.row]

        }
        else {
            cell?.textLabel?.text = exerciseArray[indexPath.row]
        }
        return cell!
    }
    
    //MARK: -- Functions for searching in the searchBar
    
    //Function that checks what the user entered
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter exercises based on what the user is searching for
        filteredExercises = exerciseArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tblView.reloadData()
    }
    
    //Function for cancel button within searchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    //Function to check if user tapped search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
    }
    

    
    
}

