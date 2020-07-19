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

class GroupExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var DJSearchButton: UIButton!
    @IBOutlet weak var groupSearchButton: UIButton!
    
    var group: Group?
    var results: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
            }
        }
        
        let db = Firestore.firestore()
        db.collection("DJs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if self.results == nil {
                        self.results = [document.documentID]
                    } else {
                        self.results?.append(document.documentID)
                    }
                }
                self.searchResultsTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(round(Double(results?.count ?? 0) / 2.0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! ExplorePageSearchResultCell
        if indexPath.row*2 < results?.count ?? 0, let id = results?[indexPath.row*2] {
            cell.setupLeft(djID: id)
        } else {
            cell.hideLeft()
        }
        if indexPath.row*2 + 1 < results?.count ?? 0, let id = results?[indexPath.row*2 + 1] {
            cell.setupRight(djID: id)
        } else {
            cell.hideRight()
        }
        return cell
    }    
}
