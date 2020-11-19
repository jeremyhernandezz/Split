//
//  AddExerciseViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/7/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {

    //Display outlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Input Outlets
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var addButtonLabel: UIButton!
    
    //Variable for exercise name passed from secondViewController
    var name: String?
    var imageName = ""
    private var datePicker: UIDatePicker?
    
    //Array to store user selections
    var itemsArray: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes create account button rounded
        addButtonLabel.layer.cornerRadius = 20
        addButtonLabel.clipsToBounds = true
        
        //Instance of datePicker and setting textField to display date selection
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddExerciseViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        
        setUI()
    }
    
    //Button to add selected exercise
    @IBAction func addButton(_ sender: Any) {
        
        //Checks if the user entered a date. If not, it sets it to current date.
        var defaultDate = ""
        if dateTextField.text!.isEqual("") {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM dd, yyyy"
            defaultDate = formatter.string(from: date)
        } else { defaultDate = dateTextField.text!}
        
        //Greate object with user inputs and passed defaults just in case
        let tempExercise = Exercise(json:["name": imageName, "date": defaultDate, "duration": Int(durationTextField.text!) ?? 0 , "sets": Int(setsTextField.text!) ?? 0 , "reps": Int(repsTextField.text!) ?? 0 ])
        
        //Decode array to get previous array
        do {
            if UserDefaults.standard.object(forKey: "items") != nil {
                if let decodedArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "items") as! Data)) as? [Exercise] {
                    itemsArray = decodedArray
                }
            }

        } catch {
            print("Couldn't decode data")
        }
        
        //Append new item
        itemsArray.append(tempExercise)
        
        //Persist data
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: itemsArray)
        UserDefaults.standard.set(encodedData, forKey: "items")
        
        //Takes the user to the selection page
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    //Function that set's name of exercise
    func setUI() {
        
        let descriptions = getInformation()
        //Allows the user to tap anywhere on the screen to exit keyboard (Could be moved to viewDidLoad) 
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddExerciseViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        exerciseNameLabel.text = name
        imageName = name!
        exerciseImage.image = UIImage(named: imageName)
        descriptionLabel.text = descriptions[imageName]
    }
    
    //Function to end editing a text field if user taps anywhere in the screen
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //Function for changind date
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        
        //Sets the datePicker.date to a string
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    //Function that returns a dictionary of the descriptions of each exercise
    func getInformation () ->[String:String] {
        
        //Dictionary of exercises
        let descriptions: [String:String] = [
            "Lunges": "A lunge can refer to any position of the human body where one leg is positioned forward with knee bent and foot flat on the ground while the other leg is positioned behind.",
            "Pushups": "A push-up is a common calisthenics exercise beginning from the prone position." ,
            "Squats": "A squat is a strength exercise in which the trainee lowers their hips from a standing position and then stands back up." ,
            "Burpees": "The burpee, is a full body exercise used in strength training and as an aerobic exercise." ,
            "Situps": "The sit-up is an abdominal endurance training exercise to strengthen, tighten and tone the abdominal muscles.",
            "Crunches": "The crunch is one of the most popular abdominal exercises. It involves the entire abs, but primarily it works the rectus abdominis muscle and also works the obliques.",
            "Dumbbell rows": "The dumbbell row is a basic exercise that strengthens the back, shoulders, and biceps while actively engaging the core throughout the movement. - muscleandfitness.com",
            "Side planks": "A side plank is a upper body and bodyweight exercise that works the core muscles as well as improves back stability.",
            "Glute bridge": "The Glute Bridge is one of the most effective exercises to tone the glutes and the hamstrings. It is a lower body workout that isolates and strengthens the glutes, hamstrings, and the core stability muscles.",
            "Pullups": "A pull-up is an upper-body strength exercise. The pull-up is a closed-chain movement where the body is suspended by the hands and pulls up.",
            "Deadlifts": "The deadlift is a weight training exercise in which a loaded barbell or bar is lifted off the ground to the level of the hips, torso perpendicular to the floor, before being placed back on the ground.",
            "Kettlebell swings": "Kettlebell swings combine strength and cardio, which is key to getting your heart rate up while also strengthening your arms and leg muscles.",
            "Donkey kicks": "Donkey kicks target the glutes in a way many other compound exercises can’t. It is also know as the quadruped bent-knee hip extension",
            "Triceps kickbacks": "Triceps kickback is an exercise that works almost exclusively on your triceps. The targeted triceps workout will help you lose arm fat over time and build muscle.",
            "Planks": "The plank is an isometric core strength exercise that involves maintaining a position similar to a push-up for the maximum possible time.",
            "Pulldown": "The pulldown exercise is a strength training exercise designed to develop the latissimus dorsi muscle. ",
            "Bench press": "The bench press is an upper-body weight training exercise in which the trainee presses a weight upwards while lying on a weight training bench.",
            "Barbell curl": "The Barbell curl is one of the most populer exercises, it helps build sleeve-popping biceps and allows heavier loading than many other curl variations",
            "Skaters": "Skater jumps are a great cardio exercise involving jumping in a pattern that shifts your body weight from side to side to create a skating stride. ",
            "Leg press": "The leg press is a weight training exercise in which the individual pushes a weight or resistance away from them using their legs.",
            "Leg extension": "The leg extension is a resistance weight training exercise that targets the quadriceps muscle in the legs. ",
            "Dumbbell flye": "The dumbbell chest fly is a popular exercise that targets the pectoral or chest muscles.",
            "Goblet squat": "The Goblet Squat is a lower-body exercise in which you hold a dumbbell or kettlebell with both hands in front of your chest.",
            "Battling ropes": "Battling ropes are used for fitness training to increase full body strength and conditioning.",
            "Reverse lunge": "A reverse lunge is where you'll be stepping backward with one of your legs",
            "Back squat": "The Back Squat is a lower-body exercise that strengthens the glutes, hamstrings and quads.",
            "Rowing": "The rowing machine mimics the the motion of rowing a boat in water, making it an execellent full body workout",
            "Standing pulldown": "Similar to the pulldown, the stading pulldown exercise is a strength training exercise designed to develop the latissimus dorsi muscle.",
            "TRX triceps press" : "The TRX triceps press uses suspension straps and your own bodyweight instead of typical free weights, machines, or cables.",
            "Boxing": " A two for one cardio and strength workout, boxing improves overall fitness output workout",
            "Jogging": "Jogging is a form of trotting or running at a slow or leisurely pace."]
        
        return descriptions
    }

}
