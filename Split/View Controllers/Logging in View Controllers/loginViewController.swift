//
//  loginViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/17/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class loginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Outlets for user inputs 
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    //Variables and arrays to store data
    var weights = [String]()
    var heights = [String]()
    var ages = [String]()
    var genders = ["Male", "Female"]
    
    //PickerView objects 
    var pickerViewWeight = UIPickerView()
    var pickerViewHeight = UIPickerView()
    var pickerViewGender = UIPickerView()
    var pickerViewAge = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lets the user exit input selection by tapping anywhere on the screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(UpdateWeightViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Populate age, height and weights arrays with their values
        createArrays()
        
        //Set up picker views
        setPickerViews ()
        
        //Makes create account button rounded
        createAccountButton.layer.cornerRadius = 20
        createAccountButton.clipsToBounds = true
    }
    
    //Functions required for pickerView 
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewHeight {
            return heights.count
        } else if pickerView == pickerViewWeight {
            return weights.count
        } else if pickerView == pickerViewAge {
            return ages.count
        } else if pickerView == pickerViewGender {
            return genders.count
        }
        return 1
    }
       
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView ==  pickerViewHeight{
            return heights[row]
       } else if pickerView == pickerViewWeight {
           return weights[row]
       } else if pickerView == pickerViewAge {
            return ages[row]
       } else if pickerView == pickerViewGender {
            return genders[row]
        }
        return ""
    }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
        if pickerView == pickerViewHeight {
            heightTextField.text = heights[row]
            heightTextField.resignFirstResponder()
        } else if pickerView == pickerViewWeight {
            weightTextField.text = weights[row]
            weightTextField.resignFirstResponder()
        } else if pickerView == pickerViewAge {
            ageTextField.text = ages[row]
            ageTextField.resignFirstResponder()
        } else if pickerView == pickerViewGender {
            genderTextField.text = genders[row]
            genderTextField.resignFirstResponder()
        }
        
    }
    
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //Function that populates array.
    func createArrays() {
        for i in 0..<501 {
            weights.append(String(i))
        }
        
        for i in 0..<100 {
            ages.append(String(i))
        }
        
        for i in 0..<9 {
            for j in 0..<12 {
                heights.append(String(i) + "' " + String(j) + "\"")
            }
        }
    }
    
    //Function that set PickerView object delegates, detaSource and updates textfields
    func setPickerViews() {
        
        //PickerView information
        pickerViewWeight.delegate = self
        pickerViewWeight.dataSource = self
        
        pickerViewHeight.delegate = self
        pickerViewHeight.dataSource = self
        
        pickerViewAge.delegate = self
        pickerViewAge.dataSource = self
        
        pickerViewGender.delegate = self
        pickerViewGender.dataSource = self
        
        //Assigned pickerview with text field and properties
        weightTextField.inputView = pickerViewWeight
        weightTextField.textAlignment = .left
        weightTextField.placeholder = "Select Weight"
        
        //Assigned pickerview with text field
        heightTextField.inputView = pickerViewHeight
        heightTextField.textAlignment = .left
        heightTextField.placeholder = "Select Height"
        
        ageTextField.inputView = pickerViewAge
        ageTextField.textAlignment = .left
        ageTextField.placeholder = "Select Age"
        
        genderTextField.inputView = pickerViewGender
        genderTextField.textAlignment = .left
        genderTextField.placeholder = "Select Gender"
    }
    
    //Function that createUser account
    @IBAction func createAccount(_ sender: Any) {
        
        //Object with the current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let defaultDate = formatter.string(from: date)
        
        //Save user login status
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
        
        //Check if user entered any data
        if firstNameTextField.text!.isEmpty { firstNameTextField.text = "User"}
        if lastNameTextField.text!.isEmpty { lastNameTextField.text = "N\\A"}
        if genderTextField.text!.isEmpty { genderTextField.text = "N\\A"}
        if heightTextField.text!.isEmpty { heightTextField.text = "N\\A"}
        if weightTextField.text!.isEmpty { weightTextField.text = "0"}

        
        //Create temp user object to save user input and store.
        let user = User(json:["firstName": firstNameTextField.text ?? "N\\A" , "lastName": lastNameTextField.text ?? "N\\A" , "gender": genderTextField.text ?? "N\\A" , "age": Int(ageTextField.text!) ?? 0 , "height": heightTextField.text ?? "N\\A", "duration": 0, "sets": 0, "reps": 0 ])
        
        //Persist data
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
               UserDefaults.standard.set(encodedData, forKey: "user")
        
        //String array to store weights
        var savedWeights = [Weight]()
        
        //Create temp user object to save user input and store.
        let weightTemp = Weight(json:["weight": weightTextField.text ?? "0" , "date": defaultDate])
        
        savedWeights.append(weightTemp)
        
        //Persist data
        let encodedWeight = NSKeyedArchiver.archivedData(withRootObject: savedWeights)
        UserDefaults.standard.set(encodedWeight, forKey: "Weights")

    }
}


