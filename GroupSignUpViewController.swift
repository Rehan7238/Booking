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
import SkyFloatingLabelTextField;
import GooglePlaces
import PromiseKit
import Firebase



class GroupSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    var selectedTextField: UITextField?
    var geopointHolder: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BackgroundImage
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        groupNameTextField.delegate = self
        schoolTextField.delegate = self
        addressTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            retypePasswordTextField.becomeFirstResponder()
        } else if textField == retypePasswordTextField {
            groupNameTextField.becomeFirstResponder()
        } else if textField == groupNameTextField {
            schoolTextField.becomeFirstResponder()
        } else if textField == schoolTextField {
            addressTextField.becomeFirstResponder()
        } else {
            addressTextField.resignFirstResponder()
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
    
    @IBAction func textFieldTapped(_ sender: Any) {
        selectedTextField = self.addressTextField
        self.addressTextField.resignFirstResponder()
        self.addressTextField.selectedTextRange = nil
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
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        print("HELLO IS THIS WORKING")
        if passwordTextField.text != retypePasswordTextField.text {
            AlertView.instance.showAlert(message: "Please re-type password")
        } else if groupNameTextField.text?.isEmpty ?? true || schoolTextField.text?.isEmpty ?? true || addressTextField.text?.isEmpty ?? true  {
            AlertView.instance.showAlert(message: "Please enter all information")
        } else {
            if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
                    if error == nil {
                        let group = Group.createNew(withID: (result?.user.uid)!)
                        group.setName(self.groupNameTextField.text!)
                        group.setAddress(self.addressTextField.text!)
                        group.setSchool(self.schoolTextField.text!)
                        let schoolLongitude = self.geopointHolder?.longitude
                        let schoolLatitude = self.geopointHolder?.latitude
                        group.setLongitude("\(String(describing: schoolLongitude ))")
                        group.setLatitude("\(String(describing: schoolLatitude))")
                        self.performSegue(withIdentifier: "toGroupEquipmentQuestion", sender: self)
                    } else {
                        AlertView.instance.showAlert(message: "Error signing up with that email and password")
                    }
                }
            } else {
                AlertView.instance.showAlert(message: "Error signing up with that email and password")
                //either emailTextField.text or passwordTextField.text was nil
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupSignUpViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        if selectedTextField == addressTextField {
            self.addressTextField.text = place.formattedAddress
        } else if selectedTextField == self.schoolTextField {
            if (place.types?.contains("university"))!{
                self.schoolTextField.text = place.name
                self.geopointHolder = (place.coordinate)
            }
            else {
                AlertView.instance.showAlert(message: "Please enter a valid university")
            }
            
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
