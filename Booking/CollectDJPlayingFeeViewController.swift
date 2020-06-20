//
//  CollectDJPlayingFeeViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/19/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class CollectDJPlayingFeeViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playingFeeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = Auth.auth().currentUser?.uid else { return}
        _ = User.fromID(id: userID)
        
    }

    
 
    
}
