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
    
    //Mark: Properties
    
    @IBOutlet weak var x2Label: UILabel!
    
    @IBOutlet weak var x1Label: UILabel!
    
    @IBOutlet weak var o2Lbel: UILabel!
    @IBOutlet weak var o1Label: UILabel!
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBAction func signupButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
    
}
