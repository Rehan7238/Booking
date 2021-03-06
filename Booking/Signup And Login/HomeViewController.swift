//
//  HomeViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/12/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    
    var uid: String = ""
    var isGroup: Bool = false
    var dj: DJ! //will only exist if logged in as a DJ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            self.uid = uid
        }
        
        _ = DJ.fromID(id: uid).done { dj in
            if dj != nil {
                self.loggedInLabel.text = "Logged in as a dj"
                self.isGroup = false
                self.dj = dj
                self.loadDJInfo()
            }
        }
        
    }
    
    func loadClientInfo() {
        
    }
    
    func loadDJInfo() {
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch{
            print("Error while signing out!")
        }
    }
}
