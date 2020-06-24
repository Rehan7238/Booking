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
    
 
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBAction func signupButton(_ sender: Any) {
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "/Users/Eimara/Documents/Booking/Booking/Background.png")!)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "/Users/Eimara/Documents/Booking/Booking/Background.png")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)


    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
}
