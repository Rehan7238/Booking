//
//  GroupSignUpViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/13/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class GroupSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var goBackButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            //let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            //let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            AlertView.instance.showAlert(message: "Please re-type password")
            
            //alertController.addAction(defaultAction)
            //self.present(alertController, animated: true, completion: nil)
        } else if groupNameTextField.text?.isEmpty ?? true || schoolTextField.text?.isEmpty ?? true || addressTextField.text?.isEmpty ?? true {
            //let alertController = UIAlertController(title: "Information Empty", message: "Please enter all information", preferredStyle: .alert)
            //let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            //alertController.addAction(defaultAction)
            //self.present(alertController, animated: true, completion: nil)
        /AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let group = Group.createNew(withID: (result?.user.uid)!)
                        group.setName(self.groupNameTextField.text!)
                        group.setAddress(self.addressTextField.text!)
                        
                        group.setSchool(self.schoolTextField.text!)
                        
                        self.performSegue(withIdentifier: "signupToHome", sender: self)
                    } else {
                        //let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        //let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        //alertController.addAction(defaultAction)
                        //self.present(alertController, animated: true, completion: nil)
                        AlertView.instance.showAlert(message: "Try again later")

                    }
                }
            } else {
                //either emailTextField.text or passwordTextField.text was nil
            }
            self.performSegue(withIdentifier: "toGroupEquipmentQuestion", sender: self)

        }
    }
}
