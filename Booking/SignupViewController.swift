//
//  SignupViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var DJButton: UIButton!
    @IBOutlet weak var fratButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func DJButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signupToDJ", sender: self)
    }
    
    @IBAction func fratButtonPressed(_ sender: Any) {
        
    }
}
