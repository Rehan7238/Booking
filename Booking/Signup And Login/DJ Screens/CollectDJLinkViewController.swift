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
    @IBOutlet weak var backButton: UIButton!
    var dj: DJ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        _ = DJ.fromID(id: uid).done { djThatItLoaded in
            self.dj = djThatItLoaded
        }
        
    }
    
    @IBAction func pressedNext (_ sender: Any) {
        self.dj?.setPlaylist(linkTextField.text!)
        // Go to the next screen
        self.performSegue(withIdentifier: "toDJProfilePic", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
