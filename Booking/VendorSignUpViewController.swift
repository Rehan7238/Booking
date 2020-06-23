//
//  VendorSignUpViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/22/20.
//  Copyright © 2020 Rehan. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth

class VendorSignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var groupAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
                       AlertView.instance.showAlert(message: "Please re-type password")

        } else if groupNameTextField.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true || stateTextField.text?.isEmpty ?? true || groupAddressTextField.text?.isEmpty ?? true {
                        AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let vendor = Vendor.createNew(withID: (result?.user.uid)!)
                        vendor.setName(self.groupNameTextField.text!)
                        vendor.setAddress(self.groupAddressTextField.text!)
                        vendor.setCity(self.cityTextField.text!)
                        vendor.setState(self.stateTextField.text!)
                        self.performSegue(withIdentifier: "toVendorPlayingFee", sender: self)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                //either emailTextField.text or passwordTextField.text was nil
            }
            self.performSegue(withIdentifier: "toGroupEquipmentQuestion", sender: self)

        }
    }
}
