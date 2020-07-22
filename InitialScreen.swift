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
import PromiseKit

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
               _ = Group.fromID(id: uid).done { loadedGroup in
                   self.group = loadedGroup
//                   let pushManager = PushNotificationManager(userID: loadedGroup?.id ?? "")
//                       pushManager.registerForPushNotifications()
               }
        }
    }
    
    override func viewDidAppear (_ animated: Bool) {
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
        _ = self.checkDJ().done { isDJ in
            if isDJ {
                self.performSegue(withIdentifier: "toDJ", sender: nil)
            }
        }
        
        _ = self.checkUser().done { isUser in
            if isUser {
                self.performSegue(withIdentifier: "toSocializer", sender: nil)
            }
        }

        _ = self.checkVendor().done { isVendor in
            if isVendor {
                self.performSegue(withIdentifier: "toVendor", sender: nil)
            }
        }
        
        _ = self.checkGroup().done { isGroup in
            if isGroup {
                self.performSegue(withIdentifier: "toGroup", sender: nil)
            }
        }
    }
    
    func checkDJ() -> Promise<Bool> {
        let (promise, resolver) = Promise<Bool>.pending()
        
        print ("check dj")

        _ = DJ.fromID(id: uid).done { dj in
            if dj != nil {
                self.isGroup = false
                self.dj = dj
                resolver.fulfill(true)
            } else {
                resolver.fulfill(false)
            }
        }
        return promise
    }
    
    func checkUser() -> Promise<Bool> {
        let (promise, resolver) = Promise<Bool>.pending()

        print("check user")
        _ = User.fromID(id: uid).done { user in
            if user != nil {
                self.isGroup = false
                self.user = user
                resolver.fulfill(true)
            } else {
                resolver.fulfill(false)
            }
        }

        return promise
    }
    
    func checkVendor() -> Promise<Bool> {
        let (promise, resolver) = Promise<Bool>.pending()

        print("check vendor")

        _ = Vendor.fromID(id: uid).done { vendor in
            if vendor != nil {
                self.isGroup = true
                self.vendor = vendor
                resolver.fulfill(true)
            } else {
                resolver.fulfill(false)
            }
        }
        return promise
    }
    
    func checkGroup() -> Promise<Bool> {
        let (promise, resolver) = Promise<Bool>.pending()

        print("check group")

        _ = Group.fromID(id: uid).done { group in
            if group != nil {
                self.isGroup = true
                self.group = group
                resolver.fulfill(true)
                //self.loadDJInfo()
            } else {
                resolver.fulfill(false)
            }
        }
        return promise
    }
}
