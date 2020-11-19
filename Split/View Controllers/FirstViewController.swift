//
//  FirstViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 6/24/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit
import CardSlider

//Defines properties of item and item object
struct Item: CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
    
}

//First ViewController that inherites the UIViewController and CardSliderDataSource class
class FirstViewController: UIViewController, CardSliderDataSource {
    
    //Array of items
    var data = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prints the itemCards
        let vc = CardSliderViewController.with(dataSource: self)
        vc.title = "Welcome to Sp\\it."
        vc.modalPresentationStyle = .currentContext
        present(vc, animated: true)
        
        //Appends items to the CardItem
        data.append(Item(image: UIImage(named: "suggestion3")!,
                         rating: nil,
                         title: "What is Sp\\it?",
                         subtitle: "Get excited about the new app",
                         description: "You can now keep track of your workout more easily than ever before. Sp\\it allows you to keep track of all you weekly and daily workout progress and routines. You can also set new daily goals and keep track of when you meet those targets you work so hard on for. Split also provides you with a graph to view your weight loss over time in our Profile page."))
        
        data.append(Item(image: UIImage(named: "suggestion2")!,
                         rating: nil,
                         title: "Suggestions",
                         subtitle: "Have u ever tried to ramp up your sets?",
                         description: "Try one of our many set's exercises descripbed on our workout pages. And if you'refeeling like having a bigger challenge try some of our recomended deadlift exercises"))
        
        data.append(Item(image: UIImage(named: "suggestion4")!,
        rating: nil,
        title: "3 of The Most Effective Exercises",
        subtitle: "Get the most out of your workout?",
        description: "When it comes to working out, you get out what you put in. I order to maximize your output and be more efficient try to mix and match from our list of most recommended execises:\n\n1.) Squats - Squats give you the most bang for your buck in terms of exercising the most muscle groups.\n\n2.) Lunges - Like squats, lunges work all the major muscles of the lower body. They also help you improve balance.\n\n3.) Push-ups - When done correctly, the push-up can strengthen the chest, triceps, shoulders, and even the core trunk muscles, all at the same time. "))
        
        data.append(Item(image: UIImage(named: "suggestion1")!,
                         rating: nil,
                         title: "Want more from the app?",
                         subtitle: "See what is coming soon for Split",
                         description: "Future updates of Split will include a larger variaty of workout exercises and activities.\nYou can also expect to see a chronometer (Timer) feature added as well as a set notification option that will remind you of your daily goals. Another cool feature we are planning to is the option to import your own profile image.\n"))

    }
    
    //Function required by CardSlider
    func item(for index: Int) -> CardSliderItem {
        return data[index]
    }
    
    //Returns numebr of Items
    func numberOfItems() -> Int {
        return data.count
    }


}

