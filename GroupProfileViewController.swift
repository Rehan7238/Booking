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
import FirebaseFirestore
import GooglePlaces

class GroupProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //Mark: Properties
    
    var group: Group?
    var request: Request?
    var uid: String = ""
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
   
    var results: [String] = [String]()
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
                self.schoolLabel.text = self.group?.school
                self.refreshData()
              
                if let headerImage = self.group?.headerImage, !headerImage.isEmpty {
                    self.headerImage.downloadImage(from: URL(string: headerImage)!)
                }
                else {
                    self.headerImage.image = UIImage(named: "chooseImageTwo")
                }
            }
        }
        //edit the header picture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupProfileViewController.handleSelectProfile))
        headerImage.clipsToBounds = true;
        headerImage.layer.borderWidth = 0;
        headerImage.addGestureRecognizer(tapGesture)
        headerImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfile () {
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
        pickerController.delegate = self
        confirmButton.isHidden = false
    }
    
    @objc func refresh() {
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
                self.schoolLabel.text = self.group?.school
                self.refreshData()

                if let headerImage = self.group?.headerImage, !headerImage.isEmpty {
                    self.headerImage.downloadImage(from: URL(string: headerImage)!)
                }
                else {
                    self.headerImage.image = UIImage(named: "chooseImageTwo")
                }
            }
        }
    }
    
    func refreshData() {
        let db = Firestore.firestore()
        
        db.collection("Requests").whereField("hostID", isEqualTo: group?.id ?? "").getDocuments()
         { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.results = [String]()
                for document in querySnapshot!.documents {
                    self.results.append(document.documentID)
                }
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
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
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was declined
            else if loadedRequest?.status == "declined" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusDeclined", owner: nil, options: nil)?.first as? checkRequestStatusDeclined {
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
                // if the status was countered
            else if loadedRequest?.status == "countered" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusCounter", owner: nil, options: nil)?.first as? checkRequestStatusCounter {
                    showRequestVC.setup(uid: selectedRequestid)
                    self.present(showRequestVC, animated: true, completion: nil)
                }
            }
            else if loadedRequest?.status == "accepted" {
                if let showRequestVC = Bundle.main.loadNibNamed("checkRequestStatusAcceptedGroup", owner: nil, options: nil)?.first as? checkRequestStatusAcceptedGroup {
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
    
    @IBAction func pressedConfirm(_sender: Any){
        if let uid = Auth.auth().currentUser?.uid {
            self.uid = uid
        }
        
        let storageRef = Storage.storage().reference(forURL:"gs://djbooking-f3a55.appspot.com").child("header_image").child(uid)
        
        if let profileImg = self.selectedImage ,let imageData = profileImg.jpegData(compressionQuality: 0.1){
            print ("MADE IT INTO THE IF STATEMENT")
            
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    //let pathString = downloadURL.path // String
                    self.group?.setHeaderImage(downloadURL.absoluteString)
                    print("woooo", self.group?.headerImage)
                }
            }
        }
        confirmButton.isHidden = true
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

extension GroupProfileViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImage = image
            headerImage.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
}
