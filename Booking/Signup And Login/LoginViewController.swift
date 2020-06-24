//
//  LoginViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/12/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField! //{
       // didSet {
      //     iconTextField.tintColor = UIColor.lightGray
          // iconTextField.setIcon(imageLiteral(resourceName: "icon-user"))
       // } https://medium.com/nyc-design/swift-4-add-icon-to-uitextfield-48f5ebf60aa1
    //}
   
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var makeAnAccountLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

extension UITextField {
func setIcon(_ image: UIImage) {
   let iconView = UIImageView(frame:
                  CGRect(x: 10, y: 5, width: 20, height: 20))
   iconView.image = image
   let iconContainerView: UIView = UIView(frame:
                  CGRect(x: 20, y: 0, width: 30, height: 30))
   iconContainerView.addSubview(iconView)
   leftView = iconContainerView
   leftViewMode = .always
}
}

