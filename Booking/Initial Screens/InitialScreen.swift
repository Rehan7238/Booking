//
//  InitialScreen.swift
//  Booking
//
//  Created by Eimara Mirza on 6/24/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class InitialScreen: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!

    
    var uid: String = ""
    var isGroup: Bool = false
    var dj: DJ! //will only exist if logged in as a DJ
    var user: User!
    var group: Group!
    var vendor: Vendor!
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid {
        self.uid = uid
            
    }
       
}
    override func viewDidAppear (_ animated: Bool){
        titleLabel.isHidden = false
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [], animations: { () -> Void in

            self.titleLabel.alpha = 0

            }, completion: { (finished: Bool) -> Void in
                print("animation FINISHED")
                // next animation
                self.checkType()
        })
        
    }
    
    func checkType() {
        if checkDJ() != nil {
                               self.performSegue(withIdentifier: "toDJ", sender: nil)

               }
               
               else if checkUser() != nil {
                   self.performSegue(withIdentifier: "toSocializer", sender: nil)
               }
               else if checkVendor() != nil {
                   self.performSegue(withIdentifier: "toVendor", sender: nil)
               }
               else if checkGroup() != nil {
                   self.performSegue(withIdentifier: "toGroup", sender: nil)
               }
           
    }
    
    func checkDJ() {
        _ = DJ.fromID(id: uid).done { dj in
            if dj != nil {
                self.isGroup = false
                self.dj = dj
                //self.loadDJInfo()
            }
        }
    }
    
    func checkUser() {
        _ = User.fromID(id: uid).done { user in
            if user != nil {
                self.isGroup = false
                self.user = user
            }
        }
    }
    
    func checkVendor() {
        _ = Vendor.fromID(id: uid).done { vendor in
            if vendor != nil {
                self.isGroup = true
                self.vendor = vendor
            }
        }
    }
    
    func checkGroup() {
        _ = Group.fromID(id: uid).done { group in
            if group != nil {
                self.isGroup = true
                self.group = group
                //self.loadDJInfo()
            }
        }
    }

}
