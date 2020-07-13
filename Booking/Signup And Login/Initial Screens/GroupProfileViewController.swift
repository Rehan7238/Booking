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
import Firebase
import FirebaseStorage
import GooglePlaces

class GroupProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    
    var group: Group?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var results: [String] = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 6
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.refreshData()
                self.groupName.text = self.group?.name
                self.addressLabel.text = self.group?.address
                self.schoolLabel.text = self.group?.school
                if let profilePic = self.group?.profilePic, !profilePic.isEmpty {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    
                }

            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 6
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.refreshData()
                self.groupName.text = self.group?.name
                self.addressLabel.text = self.group?.address
                self.schoolLabel.text = self.group?.school
                if let profilePicURL = self.group?.profilePic, let url = URL(string: profilePicURL) {
                    self.profilePic.downloadImage(from: url)

                }

            }
        }
    }
    
    func refreshData() {
           let db = Firestore.firestore()

           db.collection("Events").whereField("school", isEqualTo: group?.school ?? "").getDocuments() { (querySnapshot, err) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        let id = results[indexPath.row]
        cell.setup(eventID: id)
        cell.layer.cornerRadius = cell.frame.height / 3
        return cell
    }
}

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
