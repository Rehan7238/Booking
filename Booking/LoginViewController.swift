//
//  LoginViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/12/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Properties
    
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
   
     @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func loginAction(_ sender: Any) {
          
    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
       if error == nil{
         self.performSegue(withIdentifier: "loginToHome", sender: self)
                      }
        else{
         let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
          alertController.addAction(defaultAction)
          self.present(alertController, animated: true, completion: nil)
             }
    }
            
    }
    
}

