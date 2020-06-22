//
//  ShareContactsPermissionViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/18/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class ShareContactsPermissionViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed () {
        
        self.performSegue(withIdentifier: "toSocializerFinalNotes", sender: self)
        
    }
}
