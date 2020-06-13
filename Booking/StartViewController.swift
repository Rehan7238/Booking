//
//  StartViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/12/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //Mark: Properties
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBAction func signupButton(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool){
     super.viewDidAppear(animated)
     if Auth.auth().currentUser != nil {
       self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
    }
    }
    
}
