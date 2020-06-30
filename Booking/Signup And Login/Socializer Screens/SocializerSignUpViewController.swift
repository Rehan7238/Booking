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
import GooglePlaces
import SkyFloatingLabelTextField

class SocializerSignUpViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: Properties
    
    @IBOutlet var personalInformationTitleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField! = UITextField()
    @IBOutlet var passwordTextField: UITextField! = UITextField()
    @IBOutlet var retypePasswordTextField: UITextField! = UITextField()
    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet var cityTextField: UITextField! = UITextField()
    @IBOutlet var schoolTextField: UITextField! = UITextField()
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    var selectedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        nameTextLabel.delegate = self
        cityTextField.delegate = self
        schoolTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            retypePasswordTextField.becomeFirstResponder()
        } else if textField == retypePasswordTextField {
            nameTextLabel.becomeFirstResponder()
        } else if textField == nameTextLabel {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            schoolTextField.becomeFirstResponder()
        } else {
            schoolTextField.resignFirstResponder()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 3 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @IBAction func citytextFieldTapped(_ sender: Any) {
        selectedTextField = self.cityTextField
        self.cityTextField.resignFirstResponder()
        self.cityTextField.selectedTextRange = nil
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func schoolFieldTapped (_ sender: Any) {
        selectedTextField = self.schoolTextField
        self.schoolTextField.resignFirstResponder()
        self.schoolTextField.selectedTextRange = nil
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")
        } else if nameTextLabel.text?.isEmpty ?? true || cityTextField.text?.isEmpty ?? true {
            AlertView.instance.showAlert(message: "Please enter all information")
        } else {
            
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let user = User.createNew(withID: (result?.user.uid)!)
                        user.setName(self.nameTextLabel.text!)
                        user.setLocality(self.cityTextField.text!)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SocializerSignUpViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        if selectedTextField == cityTextField {
            self.cityTextField.text = place.formattedAddress
        } else if selectedTextField == self.schoolTextField {
            self.schoolTextField.text = place.formattedAddress
        }
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
