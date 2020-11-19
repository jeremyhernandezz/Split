//
//  GoalsViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/18/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    //Outlets
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setGoalsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lets the user exit input selection by tapping anywhere on the screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(UpdateWeightViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Makes button rounded
        setGoalsButton.layer.cornerRadius = 20
        setGoalsButton.clipsToBounds = true
    }
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }

    //Action that sets the daily goals
    @IBAction func setGoals(_ sender: Any) {
        
        //Decode user object to get user informatio and update
        do {
            if UserDefaults.standard.object(forKey: "user") != nil {
                if let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "user") as! Data)) as? User {
                    let savedUser = decodedUser
                    
                    //Check if user enter inputs for each textField, if so update or not
                    if durationTextField.text!.isEmpty { durationTextField.text = "0"}
                    if setsTextField.text!.isEmpty { setsTextField.text = "0"}
                    if repsTextField.text!.isEmpty { repsTextField.text = "0"}
                    
                    //Set the values to the new user inputed goals
                    savedUser.duration! = Int(durationTextField.text!)!
                    savedUser.sets! = Int(setsTextField.text!)!
                    savedUser.reps! = Int(repsTextField.text!)!
                    
                    //Persist data
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: savedUser)
                           UserDefaults.standard.set(encodedData, forKey: "user")
                }
            }

        } catch {
            print("Couldn't decode data")
        }
        
        //Jumps to the tab bar controller view
        guard let tabVC = storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController else {
            return
        }
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
}
