//
//  CollectDJPlayingFeeViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/19/20.
//  Copyright © 2020 Rehan. All rights reserved.


import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class CollectDJPlayingFeeViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var playingFeeText: UITextField! = UITextField()
    var dj: DJ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        _ = DJ.fromID(id: uid).done { djThatItLoaded in
            self.dj = djThatItLoaded
        }
    }
    
    @IBAction func pressedNext (_ sender: Any) {
        if let value = playingFeeText.text, !value.isEmpty {
            self.dj?.setPlayingFee(NSNumber.init( value: Int32(value)!))
        }
        
        // Go to the next screen
        self.performSegue(withIdentifier: "toEquipmentQuestion", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
