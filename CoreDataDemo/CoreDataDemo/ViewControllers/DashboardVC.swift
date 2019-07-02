//
//  DashboardVC.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreateUser(_ sender: Any) {
        
        let username = usernameField.text?.trimWhiteSpace
        let password = passwordField.text?.trimWhiteSpace

        if username!.length == 0 && password!.length == 0 {
            AlertController.alert(title: "Invalid inputs")
        } else {
            DBHandler.createUser(username: username!, password: password!)
            AlertController.alert(title: "User created")
            usernameField.text? = ""
            passwordField.text? = ""
        }
    }
    
    @IBAction func onViewUsers(_ sender: Any) {
        
    }
 
}

