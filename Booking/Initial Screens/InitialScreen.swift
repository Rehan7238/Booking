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
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [], animations: { () -> Void in

            self.titleLabel.alpha = 0

            }, completion: { (finished: Bool) -> Void in
                print("animation FINISHED")
                // next animation
                self.checkType()
        })
        
    }
    
    func checkType() {
                if checkDJ(){
                    self.performSegue(withIdentifier: "toDJ", sender: nil)
               }
               
                else if checkUser(){
                   self.performSegue(withIdentifier: "toSocializer", sender: nil)
               }
                else if checkVendor() {

                   self.performSegue(withIdentifier: "toVendor", sender: nil)
               }
                else if checkGroup()  {

                   self.performSegue(withIdentifier: "toGroup", sender: nil)
               }
           
    }
    
    func checkDJ() -> Bool {
        print ("check dj")

        var flag  = false
        _ = DJ.fromID(id: uid).done { dj in
            if dj != nil {
                self.isGroup = false
                self.dj = dj
                flag = true
                //self.loadDJInfo()
            }
        }
        
        return flag
    }
    
    func checkUser() -> Bool {
        print("check user")
        var flag = false
        _ = User.fromID(id: uid).done { user in
            if user != nil {
                self.isGroup = false
                self.user = user
                flag = true
            }
            print("gdfgd", flag)

        }
        print("dfgdfrytt", flag)

        return flag
    }
    
    func checkVendor() -> Bool{
        print("check vendor")

        var flag = false
        _ = Vendor.fromID(id: uid).done { vendor in
            if vendor != nil {
                self.isGroup = true
                self.vendor = vendor
                flag = true
            }
        }
        return flag
    }
    
    func checkGroup() -> Bool{
        print("check group")

        var flag = false
        _ = Group.fromID(id: uid).done { group in
            if group != nil {
                self.isGroup = true
                self.group = group
                flag = true
                //self.loadDJInfo()
            }
        }
        return flag
    }

}
