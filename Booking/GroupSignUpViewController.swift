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
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var goBackButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")
        } else if groupNameTextField.text?.isEmpty ?? true || schoolTextField.text?.isEmpty ?? true || addressTextField.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true || stateTextField.text?.isEmpty ?? true {
            AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let group = Group.createNew(withID: (result?.user.uid)!)
                        group.setName(self.groupNameTextField.text!)
                        group.setAddress(self.addressTextField.text!)
                        group.setSchool(self.schoolTextField.text!)
                        group.setCity(self.cityTextField.text!)
                        group.setState(self.stateTextField.text!)
                        self.performSegue(withIdentifier: "toGroupEquipmentQuestion", sender: self)
                    } else {
                        AlertView.instance.showAlert(message: "Error signing up with that email and password")

                    }
                }
            } else {
                //either emailTextField.text or passwordTextField.text was nil
            }
        }
    }
}
