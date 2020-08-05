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
    var request: Request?
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileCard: UIView!
    
    var results: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
       profilePic.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        profilePic.layer.borderWidth = 1.0


        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
                self.schoolLabel.text = self.group?.school
                self.refreshData()
                if let profilePic = self.group?.profilePic, !profilePic.isEmpty {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //BackgroundImage
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
                self.schoolLabel.text = self.group?.school
                self.refreshData()
                if let profilePicURL = self.group?.profilePic, let url = URL(string: profilePicURL) {
                    self.profilePic.downloadImage(from: url)
                    
                }
                
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
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequestid = results[indexPath.row]
        print (selectedRequestid)
        // show different view controllers based on different cases
        _ = Request.fromID(id: selectedRequestid).done { loadedRequest in
            self.request = loadedRequest
            
            //if the status is open
            if loadedRequest?.status == "open" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusOpen", owner: nil, options: nil)?.first as? checkRequestStatusOpen {
                    showRequestVC.parentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was declined
            else if loadedRequest?.status == "declined" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusDeclined", owner: nil, options: nil)?.first as? checkRequestStatusDeclined {
                    showRequestVC.parentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was countered
            else if loadedRequest?.status == "countered" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusCounter", owner: nil, options: nil)?.first as? checkRequestStatusCounter {
                    showRequestVC.parentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
            else if loadedRequest?.status == "accepted" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusAcceptedGroup", owner: nil, options: nil)?.first as? checkRequestStatusAcceptedGroup {
                    showRequestVC.parentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do { try Auth.auth().signOut() }
        catch {
            print("already logged out")
        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
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
