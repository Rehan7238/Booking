//
//  SignupViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class DJSignupViewController: UIViewController {
    
    //Mark: Properties
    
    @IBOutlet weak var personalInformationTitleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordLabel: UILabel!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var universityAffiliationLabel: UILabel!
    @IBOutlet weak var uniAffiliationTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")

        } else if nameTextField.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true || stateTextField.text?.isEmpty ?? true {
                       AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        
                        let dj = DJ.createNew(withID: (result?.user.uid)!)
                        dj.setName(self.nameTextField.text!)
                        dj.setLocality([self.cityTextField.text!: self.stateTextField.text!])
                        dj.setUniversity(self.uniAffiliationTextField.text!)
                        self.performSegue(withIdentifier: "signupToQuestions", sender: self)
                    }
                    else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                //either emailTextField.text or passwordTextField.text was nil
            }
        }
    }
    
}
