//
//  EditViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/16/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Action that allows the user to log out and delete account 
    @IBAction func logOut(_ sender: Any) {
        
        //Prints alert to screen to verify if user wishes to log out and delete account
        let alert = UIAlertController(title: "Do you want to log out and delete account?", message: "Logging out will cause all your data be reset.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //Deletes bool value that their is a user logged in
            UserDefaults.standard.set(false, forKey: "UserLoggedIn")
            //Deletes user 
            UserDefaults.standard.removeObject(forKey: "user")
            //Deletes activity history
            UserDefaults.standard.removeObject(forKey: "items")
            
            //performs segue to initial view controller
            self.performSegue(withIdentifier: "unwindToInitialViewController", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
