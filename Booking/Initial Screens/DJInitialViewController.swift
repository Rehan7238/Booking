//
//  DJInitialViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/25/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class DJInitialViewController: UIViewController {
    
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid {
        self.uid = uid
    }
}
}
