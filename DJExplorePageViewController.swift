//
//  DJExplorePageViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/28/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase

class DJExplorePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var DJSearchButton: UIButton!
    @IBOutlet weak var groupSearchButton: UIButton!
    
    var group: Group?
    var allResults: [DJ]?
    var filteredResults: [DJ]?
    
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
                let dispatch = DispatchGroup()
                for document in querySnapshot!.documents {
                    dispatch.enter()
                    _ = DJ.fromID(id: document.documentID).done { loadedDJ in
                        if let dj = loadedDJ {
                            if self.allResults == nil {
                                self.allResults = [dj]
                            } else {
                                self.allResults?.append(dj)
                            }
                        }
                        dispatch.leave()
                    }
                }
                dispatch.notify(queue: .main) {
                    if let allResults = self.allResults {
                        for result in allResults {
                            if self.filteredResults == nil {
                                self.filteredResults = [result]
                            } else {
                                self.filteredResults?.append(result)
                            }
                        }
                    }
                    self.searchResultsTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func searchBarResultTyped(_ sender: Any) {
        if sender as? UITextField == self.searchBar {
            print("typed!")
            filteredResults = []
            if let text = searchBar.text {
                if let allResults = self.allResults {
                    for result in allResults {
                        if text.isEmpty {
                            if filteredResults == nil {
                                filteredResults = [result]
                            } else {
                                filteredResults?.append(result)
                            }
                        } else if result.name.lowercased().contains(text.lowercased()) {
                            if filteredResults == nil {
                                filteredResults = [result]
                            } else {
                                filteredResults?.append(result)
                            }
                        }
                    }
                }
                searchResultsTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(round(Double(filteredResults?.count ?? 0) / 2.0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! ExplorePageSearchResultCell
        if indexPath.row*2 < filteredResults?.count ?? 0, let id = filteredResults?[indexPath.row*2] {
            cell.setupLeft(dj: id)
        } else {
            cell.hideLeft()
        }
        if indexPath.row*2 + 1 < filteredResults?.count ?? 0, let id = filteredResults?[indexPath.row*2 + 1] {
            cell.setupRight(dj: id)
        } else {
            cell.hideRight()
        }
        return cell
    }
}

