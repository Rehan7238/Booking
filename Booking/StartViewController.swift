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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "/Users/Eimara/Documents/Booking/Booking/Background.png")!)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "/Users/Eimara/Documents/Booking/Booking/Background2.png")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
      



    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
           Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
               if error == nil{
                   self.performSegue(withIdentifier: "loginToHome", sender: self)
               } else {
                   let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                   let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   
                   alertController.addAction(defaultAction)
                   self.present(alertController, animated: true, completion: nil)
               }
           }
        
        self.performSegue(withIdentifier: "straightToLogin", sender: self)

       }
    
}
