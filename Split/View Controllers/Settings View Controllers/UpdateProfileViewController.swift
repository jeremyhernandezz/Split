//
//  UpdateProfileViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/16/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var updateButtonLabel: UIButton!
    
    //Array to store different heights, ages and genders
    var heights = [String]()
    var ages = [String]()
    var genders = ["Male", "Female"]
    
    //PickerView objects
    var pickerViewHeight = UIPickerView()
    var pickerViewGender = UIPickerView()
    var pickerViewAge = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes create account button rounded
        updateButtonLabel.layer.cornerRadius = 20
        updateButtonLabel.clipsToBounds = true
        
        //Lets the user exit input selection by tapping anywhere on the screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(UpdateWeightViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Populate age and height arrays with their values
        createArrays()
        //Sets the picker views objects
        setPickerViews ()
    }
    
    //MARK: -- PickerView functions
    
    //Functions required for pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewHeight {
            return heights.count
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
        } else if pickerView == pickerViewAge {
            ageTextField.text = ages[row]
            ageTextField.resignFirstResponder()
        } else if pickerView == pickerViewGender {
            genderTextField.text = genders[row]
            genderTextField.resignFirstResponder()
        }
        
    }
    
    //MARK: -- Set up functions
    
    //Function that populates array.
    func createArrays() {
        
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
        pickerViewHeight.delegate = self
        pickerViewHeight.dataSource = self
        
        pickerViewAge.delegate = self
        pickerViewAge.dataSource = self
        
        pickerViewGender.delegate = self
        pickerViewGender.dataSource = self
        
        //Assigned pickerview with text field and properties
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
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //Action that updates the user information
    @IBAction func updateProfile(_ sender: Any) {
        
        //Decode persisted data to get the user information
        do {
            if UserDefaults.standard.object(forKey: "user") != nil {
                if let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "user") as! Data)) as? User {
                    let savedUser = decodedUser
                    
                    //Check if user enter inputs for each textField, if so update or not
                    if firstNameTextField.text!.isEmpty { firstNameTextField.text = String(savedUser.firstName!)}
                    if lastNameTextField.text!.isEmpty { lastNameTextField.text = String(savedUser.lastName!)}
                    if genderTextField.text!.isEmpty { genderTextField.text = String(savedUser.gender!)}
                    if heightTextField.text!.isEmpty { heightTextField.text = String(savedUser.height!)}
                    if ageTextField.text!.isEmpty { ageTextField.text = String(savedUser.age!)}
                    
                    //Input the new values
                    savedUser.firstName! = firstNameTextField.text!
                    savedUser.lastName! = lastNameTextField.text!
                    savedUser.gender! = genderTextField.text!
                    savedUser.height! = heightTextField.text!
                    savedUser.age! = Int(ageTextField.text!)!
                    
                    //Persist data
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: savedUser)
                    UserDefaults.standard.set(encodedData, forKey: "user")
                }
            }

        } catch {
            print("Couldn't decode data")
        }
        self.performSegue(withIdentifier: "unwindToFifthVC", sender: self)
    }
}
