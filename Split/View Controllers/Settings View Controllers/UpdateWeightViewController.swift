//
//  UpdateWeightViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/16/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class UpdateWeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var updateButtonLabel: UIButton!
    
    //Variables and arrays to store data
    var weights = [String]()
    var pickerView = UIPickerView()
    private var datePicker: UIDatePicker?
    
    //Array to store user selections
    var weightsArray: [Weight] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes create account button rounded
        updateButtonLabel.layer.cornerRadius = 20
        updateButtonLabel.clipsToBounds = true
        
        //Lets the user exit input selection by tapping anywhere on the screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(UpdateWeightViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Function that sets pickerView delegates and textLabels
        setPickerObject()
       
    }
    
    //Function required for pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return weights.count
       }
       
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return weights[row]
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           weightTextField.text = weights[row]
           weightTextField.resignFirstResponder()
       }
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //Function for changind date
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        //Sets the datePicker.date to a string
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    //Function that sets pickerView delegates and textLabels
    func setPickerObject() {
        //Populate array with different weights
               for i in 0..<501 {
                   weights.append(String(i))
               }
               
               //PickerView information
               pickerView.delegate = self
               pickerView.dataSource = self
               
               //Assigned pickerview with text field and properties
               weightTextField.inputView = pickerView
               weightTextField.textAlignment = .center
               weightTextField.placeholder = "Select Weight"
               
               //Instance of datePicker and setting textField to display date selection
               datePicker = UIDatePicker()
               datePicker?.maximumDate = Date()
               datePicker?.datePickerMode = .date
               datePicker?.addTarget(self, action: #selector(UpdateWeightViewController.dateChanged(datePicker:)), for: .valueChanged)
               
               dateTextField.inputView = datePicker
    }

    //Function that updates values 
    @IBAction func updateWeight(_ sender: Any) {
        
        //Checks if the user entered a date. If not, it sets it to current date.
         var defaultDate = ""
         if dateTextField.text!.isEqual("") {
             let date = Date()
             let formatter = DateFormatter()
             formatter.dateFormat = "MMM d, yyyy"
             defaultDate = formatter.string(from: date)
         } else { defaultDate = dateTextField.text!}
        
        
        //Decode array to get previous array
        do {
            if UserDefaults.standard.object(forKey: "Weights") != nil {
                if let decodedWeights = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "Weights") as! Data)) as? [Weight] {
                    weightsArray = decodedWeights

                    if weightTextField.text!.isEmpty { weightTextField.text = String(weightsArray[weightsArray.count - 1].weight!)}
                    
                    //Create temp user object to save user input and store.
                    let weightTemp = Weight(json:["weight": weightTextField.text! , "date": defaultDate])
                    
                    weightsArray.append(weightTemp)
                    
                    //Persist data
                    let encodedWeight = NSKeyedArchiver.archivedData(withRootObject: weightsArray)
                    UserDefaults.standard.set(encodedWeight, forKey: "Weights")
                }
            }

        } catch {
            print("Couldn't read file.")
        }
        
        self.performSegue(withIdentifier: "unwindToFifthVC", sender: self)
    }
}
