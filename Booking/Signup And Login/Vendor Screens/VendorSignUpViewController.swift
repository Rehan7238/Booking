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
import GooglePlaces

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
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBAction func addresstextFieldTapped(_ sender: Any) {
          self.groupAddressTextField.resignFirstResponder()
          self.groupAddressTextField.selectedTextRange = nil
          let acController = GMSAutocompleteViewController()
          acController.delegate = self
          present(acController, animated: true, completion: nil)
        }
    
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")

        } else if groupNameTextField.text?.isEmpty ?? true || groupAddressTextField.text?.isEmpty ?? true {
            AlertView.instance.showAlert(message: "Please enter all information")

        } else {
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let vendor = Vendor.createNew(withID: (result?.user.uid)!)
                        vendor.setName(self.groupNameTextField.text!)
                        vendor.setAddress(self.groupAddressTextField.text!)
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
                AlertView.instance.showAlert(message: "Try again later")
            }
        }
    }
}

extension VendorSignUpViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Get the place name from 'GMSAutocompleteViewController'
    // Then display the name in textField
        self.groupAddressTextField.text = place.formattedAddress
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
