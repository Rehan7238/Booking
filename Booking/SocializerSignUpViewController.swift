//
//  SocializerSignUpViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/18/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

//
//
import Foundation
import UIKit
import FirebaseAuth

class SocializerSignUpViewController: UIViewController {
    
    //Mark: Properties
    
    @IBOutlet var personalInformationTitleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField! = UITextField()
    @IBOutlet var passwordTextField: UITextField! = UITextField()
    @IBOutlet var retypePasswordTextField: UITextField! = UITextField()
 
    @IBOutlet weak var nameTextLabel: UITextField!
    
    @IBOutlet var cityTextField: UITextField! = UITextField()
    @IBOutlet var stateTextField: UITextField! = UITextField()
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if nameTextLabel.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true || stateTextField.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Information Empty", message: "Please enter all information", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let user = User.createNew(withID: (result?.user.uid)!)
                        user.setName(self.nameTextLabel.text!)
                        self.performSegue(withIdentifier: "signupToProfile", sender: self)
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
