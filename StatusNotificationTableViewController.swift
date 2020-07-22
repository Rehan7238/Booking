//
//  StatusNotificationTableViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

//
//  GroupCalendarViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/26/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class StatusNotificationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    var group: Group?
        var request: Request?
        
        @IBOutlet weak var tableView: UITableView!
        
        var results: [String] = [String]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            
            if let uid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: uid).done { loadedGroup in
                    self.group = loadedGroup
                    self.refreshData()
                    }
                    
                }
            }

        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if let uid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: uid).done { loadedGroup in
                    self.group = loadedGroup
                    self.refreshData()
                    }
                    
                }
        }
        
        func refreshData() {
            let db = Firestore.firestore()
            db.collection("Requests").whereField("hostID", isEqualTo: group?.id ?? "").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.results = [String]()
                    for document in querySnapshot!.documents {
                        self.results.append(document.documentID)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return results.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
            let id = results[indexPath.row]
            cell.setup(requestID: id)
            cell.layer.cornerRadius = cell.frame.height / 3
            cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.layer.borderWidth = 1.0
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRequestid = results[indexPath.row]
            print (selectedRequestid)
          
        }
        
    }
