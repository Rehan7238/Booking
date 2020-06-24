//
//  DJSignupViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GooglePlaces

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
    

    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func citytextFieldTapped(_ sender: Any) {
          self.cityTextField.resignFirstResponder()
          self.cityTextField.selectedTextRange = nil
          let acController = GMSAutocompleteViewController()
          acController.delegate = self
          present(acController, animated: true, completion: nil)
        }
    
    @IBAction func schoolFieldTapped (_ sender: Any) {
          self.uniAffiliationTextField.resignFirstResponder()
          self.uniAffiliationTextField.selectedTextRange = nil
          let acController = GMSAutocompleteViewController()
          acController.delegate = self
          present(acController, animated: true, completion: nil)
      }
    
    @IBAction func signUpAction(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")

        } else if nameTextField.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true  {
                       AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        
                        let dj = DJ.createNew(withID: (result?.user.uid)!)
                        dj.setName(self.nameTextField.text!)
                        dj.setLocality(self.cityTextField.text!)
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

extension DJSignupViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Get the place name from 'GMSAutocompleteViewController'
    // Then display the name in textField
        self.cityTextField.text = place.formattedAddress
    print (place)
// Dismiss the GMSAutocompleteViewController when something is selected
    dismiss(animated: true, completion: nil)
  }

func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // Handle the error
    print("Error: ", error.localizedDescription)
  }
func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    // Dismiss when the user canceled the action
    dismiss(animated: true, completion: nil)
  }
    
    
}

