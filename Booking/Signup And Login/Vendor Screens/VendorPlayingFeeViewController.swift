//
//  VendorPlayingFeeViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/22/20.
//  Copyright © 2020 Rehan. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth


class VendorPlayingFeeViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var highPlayingFeeText: UITextField!
    @IBOutlet weak var lowPlayingFeeText: UITextField!
    @IBOutlet weak var backButton: UIButton!
    var vendor: Vendor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        _ = Vendor.fromID(id: uid).done { groupThatItLoaded in
            self.vendor = groupThatItLoaded
        }
    }
    
    @IBAction func pressedNext (_ sender: Any) {
        if let value = lowPlayingFeeText.text, !value.isEmpty {
            self.vendor?.setLowerPrice(NSNumber.init( value: Int32(value)!))
        }
        if let value = highPlayingFeeText.text, !value.isEmpty {
            self.vendor?.setHigherPrice(NSNumber.init( value: Int32(value)!))
        }
        
        // Go to the next screen
        self.performSegue(withIdentifier: "toVendorEquipmentQuestion", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
