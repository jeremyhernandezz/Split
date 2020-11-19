//
//  FifthViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/15/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit
import Charts

class FifthViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChartViewDelegate {
    
    //Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var currentWeightLabel: UILabel!
    @IBOutlet weak var weightLineChart: LineChartView!
    //@IBOutlet weak var addProfileImage: UIButton!
    @IBOutlet weak var userDefaultImage: UIImageView!
    
    //Array to store user selections
    var weightsArray: [Weight] = []
    
    //Variables to store dates array and print dates in line chart
    var dates = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        axisFormatDelegate = self
        
        //Display user information
        displayUserData()
        
        //set delegate for lineChart
        weightLineChart.delegate = self
        
        updateGraphWithData()
        
    }
    
    //Function that populates the graph with information
    func updateGraphWithData() {
        
        chartSettings()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        //Order the dates on asceding order
        let sortedArray = weightsArray.sorted(by: { dateFormatter.date(from: $0.date!)!.compare(dateFormatter.date(from: $1.date!)!) == .orderedAscending })
        
        //Saves all the dates in the sortedArray
        for objects in sortedArray {
            dates.append(String(objects.date!.prefix(3)))
        }
        
        //Persist sorted array
        let encodedWeight = NSKeyedArchiver.archivedData(withRootObject: sortedArray)
        UserDefaults.standard.set(encodedWeight, forKey: "Weights")

        
        //Create Array for data to be displayed
        var entriesArray = [ChartDataEntry]()
        
        //Populates graph with weights array data
        for x in 0..<sortedArray.count {
            //entriesArray.append(ChartDataEntry (x: Double(x), y: Double(sortedArray[x].weight!)!))
            entriesArray.append(ChartDataEntry(x: Double(x), y: Double(sortedArray[x].weight!)!, data: dates as AnyObject))
            
        }
        
        //Add lable and entries into Graph
        let set = LineChartDataSet(entries: entriesArray, label: "Weight Progress")

        set.lineWidth = 3
        //set.mode = .cubicBezier
        set.setColor(.systemGreen)
        set.valueTextColor = .systemGreen
        
        //Fills the graph
        set.fill = Fill(color: .systemGreen)
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true
        
        //Pass the set of data
        let data = LineChartData(dataSet: set)
        weightLineChart.data = data
        weightLineChart.xAxis.valueFormatter = axisFormatDelegate
        
    }
    
    //Function that is required by chart line graph but not used.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        //Not used for this project
    }
    
    //Function that customizes the line chart
    func chartSettings() {
        //Customize the graphs
        weightLineChart.leftAxis.labelTextColor = UIColor.systemGreen
        weightLineChart.rightAxis.labelTextColor = UIColor.systemGreen
        weightLineChart.xAxis.labelTextColor = UIColor.systemGreen
        weightLineChart.chartDescription?.enabled = false
        weightLineChart.isUserInteractionEnabled = true
        weightLineChart.legend.textColor = UIColor.white
        weightLineChart.legend.font =  UIFont(name: "Verdana", size: 16.0)!
        weightLineChart.rightAxis.drawLabelsEnabled = false
        weightLineChart.animate(xAxisDuration: 2.5)
        weightLineChart.noDataText = "You need to provide data for the chart."
        weightLineChart.noDataTextColor = .systemGreen
        
        //Test marker
        let marker = ChartMarker()
        marker.chartView = weightLineChart
        weightLineChart.marker = marker
    }
    
    
    //Function that makes sure navigation bar is not displayed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Function that overrides the viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Display user information
        displayUserData()
        
        //set delegate for lineChart
        weightLineChart.delegate = self

        //This was intended for the add profile image option
        //Sets the image to be rounded and adds a border
//        userDefaultImage.layer.cornerRadius = userDefaultImage.frame.size.width / 2
//        userDefaultImage.clipsToBounds = true
//        userDefaultImage.layer.borderColor = UIColor.systemGreen.cgColor
//        userDefaultImage.layer.borderWidth = 5
        
        //Present the graph
        updateGraphWithData()
        
        
    }
    
    //Function that display user information
    func displayUserData() {
        
        //Decodes user object to access user information
        do {
            if UserDefaults.standard.object(forKey: "user") != nil {
                if let decodedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "user") as! Data)) as? User {
                    let savedUser = decodedUser
                    //Sets the labels to the decoded values
                    firstNameLabel.text = savedUser.firstName!
                    lastNameLabel.text = savedUser.lastName!
                    ageLabel.text = String(savedUser.age!)
                    genderLabel.text = savedUser.gender!
                    heightLabel.text = savedUser.height!
                    durationLabel.text = String(savedUser.duration!)
                    setsLabel.text = String(savedUser.sets!)
                    repsLabel.text = String(savedUser.reps!)
                    
                    firstNameLabel.adjustsFontSizeToFitWidth = true
                    lastNameLabel.adjustsFontSizeToFitWidth = true


                }
            }

        } catch {
            print("Couldn't read file.")
        }
        
        //Decode weight array to get all the weight and dates in the array
        do {
            if UserDefaults.standard.object(forKey: "Weights") != nil {
                if let decodedWeights = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData((UserDefaults.standard.object(forKey: "Weights") as! Data)) as? [Weight] {
                    weightsArray = decodedWeights
                    //Displays the most recent weight entered by user
                    currentWeightLabel.text = String(weightsArray[weightsArray.count - 1].weight!)
                }
            }
        } catch {
            print("Couldn't decode data")
        }
    }
    
    //Action that allows user to exit from setting and return to profile page view
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        viewWillAppear(true)
    }
    
    //Action that takes the user to the setting menu
    @IBAction func editMenu(_ sender: Any) {
        
        //Shows the edit ViewController if selected
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "editVC") as? EditViewController else {
            return
        }
        present(vc, animated: true)
    }
    
    //    //Function that allows user to read photo from photo library
    //    @IBAction func addProfileImageAction(_ sender: Any) {
    //
    //        let image = UIImagePickerController()
    //        image.delegate = self
    //
    //        image.sourceType = UIImagePickerController.SourceType.photoLibrary
    //        image.allowsEditing = false
    //        self.present(image, animated: true) {}
    //
    //    }
    
        //Function that allows the user to acces the device photo library
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
    //            //Changes the background image of the button that represent user profile image
    //            addProfileImage.setImage(image, for: UIControl.State.normal)
    //            addProfileImage.autoresizingMask = UIButtonItemp
    //            imageView.contentMode = UIViewContentMode.ScaleAspectFit
    //            addProfileImage.setTitle("", for: .normal)
    //        }
    //        else {
    //            print("Error occured when loading photo")
    //        }
    //        self.dismiss(animated: true, completion: nil)
    //    }
}

//Extension that converts double to string to get the months for the xAxis in the graph
extension FifthViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return dates[Int(value)]
    }
}
