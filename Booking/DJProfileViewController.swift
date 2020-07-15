//
//  DJProfileViewController.swift
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

class DJProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var DJRatingNumber: UILabel!
    @IBOutlet weak var numberOfGigsNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dj: DJ?
    var request: Request?
    var results: [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                if let profilePic = self.dj?.profilePic {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    var calculatedRating = 0
                    if let ratings = self.dj?.hostRating {
                        for rating in ratings {
                            calculatedRating = calculatedRating + Int(truncating: rating)
                        }
                        
                        if ratings.count == 0 {
                            self.DJRatingNumber.text = "0.0"
                        } else {
                            self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings.count))"
                        }
                    }
                    self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                }
                self.refreshData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 6
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                if let profilePic = self.dj?.profilePic {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    var calculatedRating = 0
                    if let ratings = self.dj?.hostRating {
                        for rating in ratings {
                            calculatedRating = calculatedRating + Int(truncating: rating)
                        }
                        if ratings.count == 0 {
                            self.DJRatingNumber.text = "0.0"
                        } else {
                            self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings.count))"
                        }
                        self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                    }
                }
                self.refreshData()
            }
        }
    }
    
    @IBAction func InstagramAction() {
        if let dj = dj{
            let username =  dj.instagramLink// Your Instagram Username here}
            
            let appURL = URL(string: "instagram://user?username=" + (username))!
            
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: "https://instagram.com/\(username)")!
                application.open(webURL)
            }
        }
        
    }
    
    func refreshData() {
        let db = Firestore.firestore()
        
        db.collection("Requests").whereField("DJID", isEqualTo: dj?.id ?? "").getDocuments() { (querySnapshot, err) in
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequestid = results[indexPath.row]
        print (selectedRequestid)
        // show different view controllers based on different cases
        _ = Request.fromID(id: selectedRequestid).done { loadedRequest in
            self.request = loadedRequest

            if loadedRequest?.status == "open" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusOpenDJ", owner: nil, options: nil)?.first as? checkRequestStatusOpenDJ {
                    showRequestVC.DJparentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was declined
            else if loadedRequest?.status == "declined" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusDeclined", owner: nil, options: nil)?.first as? checkRequestStatusDeclined {
                    showRequestVC.DJparentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was countered
            else if loadedRequest?.status == "countered" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusCounter", owner: nil, options: nil)?.first as? checkRequestStatusCounter {
                    showRequestVC.DJparentView = self
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
            
        }
    }
}
//extension UIImageView {
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//
//    func downloadImage(from url: URL) {
//        getData(from: url) {
//            data, response, error in
//            guard let data = data, error == nil else {
//                return
//            }
//            DispatchQueue.main.async() {
//                self.image = UIImage(data: data)
//            }
//        }
//    }
//}
