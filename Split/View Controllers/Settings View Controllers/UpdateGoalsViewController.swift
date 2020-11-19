//
//  UpdateGoalsViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/16/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class UpdateGoalsViewController: UIViewController {

    //Outlets
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var updateButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes create account button rounded
        updateButtonLabel.layer.cornerRadius = 20
        updateButtonLabel.clipsToBounds = true
        
        //Lets the user exit input selection by tapping anywhere on the screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(UpdateWeightViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //Button action that updates the user goals. 
    @IBAction func UpdateGoals(_ sender: Any) {
        
        //Decode persisted data to get the user information
        do {
            if UserDefaults.standard.object(forKey: "user") != nil {
                if let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "user") as! Data)) as? User {
                    let savedUser = decodedUser
                    
                    //Check if user enter inputs for each textField, if so update or not
                    if durationTextField.text!.isEmpty { durationTextField.text = String(savedUser.duration!)}
                    if setsTextField.text!.isEmpty { setsTextField.text = String(savedUser.sets!)}
                    if repsTextField.text!.isEmpty { repsTextField.text = String(savedUser.reps!)}
                    
                    //Input the new values
                    savedUser.duration! = Int(durationTextField.text!)!
                    savedUser.sets! = Int(setsTextField.text!)!
                    savedUser.reps! = Int(repsTextField.text!)!
                    
                    //Persist data
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: savedUser)
                    UserDefaults.standard.set(encodedData, forKey: "user")
                    
                }
            }

        } catch {
            print("Couldn't read file.")
        }
        self.performSegue(withIdentifier: "unwindToFifthVC", sender: self)
    }
    
}
