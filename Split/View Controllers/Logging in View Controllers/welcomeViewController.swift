//
//  welcomeViewController.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/17/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Check if user is already logged in
        if UserDefaults.standard.bool(forKey: "UserLoggedIn") == true {
            guard let tabVC = storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController else {
                return
            }
            self.navigationController?.pushViewController(tabVC, animated: false)
        }
    }
    
    //Action allows the app to jump to initial View Controller when User logs out and deletes account
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        //Does not need anything inside
    }
}
