//
//  CollectGroupPlayingFeeViewController.swift
//  abseil
//
//  Created by Eimara Mirza on 6/21/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class CollectGroupPlayingFeeViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var higherFeeTextField: UITextField! = UITextField()
    @IBOutlet var lowFeeTextField: UITextField! = UITextField()
    
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        _ = Group.fromID(id: uid).done { groupThatItLoaded in
            self.group = groupThatItLoaded
        }
    }
    
    @IBAction func pressedNext (_ sender: Any) {
        if let value = lowFeeTextField.text, !value.isEmpty {
            self.group?.setLowerPrice(NSNumber.init( value: Int32(value)!))
        }
        if let value = higherFeeTextField.text, !value.isEmpty {
            self.group?.setHigherPrice(NSNumber.init( value: Int32(value)!))
        }
        
        // Go to the next screen
        self.performSegue(withIdentifier: "toGroupEquipmentQuestion", sender: self)
    }
    
    
}
