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
    
    @IBOutlet weak var personalInformationTitleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordLabel: UILabel!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var playingFeeLabel: UILabel!
    @IBOutlet weak var playingFeeTextLabel: UITextField!
    
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
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if playingFeeTextLabel.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true || stateTextField.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Information Empty", message: "Please enter all information", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let dj = DJ.createNew(withID: (result?.user.uid)!)
                        dj.setName(self.playingFeeTextLabel.text!)
                        self.performSegue(withIdentifier: "signupToHome", sender: self)
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
