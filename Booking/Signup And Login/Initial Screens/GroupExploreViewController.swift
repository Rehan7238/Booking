//
//  GroupExploreViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/6/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase



class GroupExploreViewController: UIViewController  {
    
    //Mark: Properties
     
     var group: Group?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
            
               
            }
        }
    }
    
   
}
