//
//  CollectDJLinkViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/19/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth




class CollectDJLinkViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
       super.viewDidLoad()
   }
    
    @IBAction func nextPressed (_ sender: Any) {
        // assign the link to the DJ's link
        
        // go to next screen
         self.performSegue(withIdentifier: "toDJProfilePicture", sender: self)
        
    }

}
