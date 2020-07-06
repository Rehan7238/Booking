//
//  GroupProfileViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/5/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth

class GroupProfileViewController: UIViewController {
    
    //Mark: Properties
    
    var group: Group?
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
            }
        }
    }
}
