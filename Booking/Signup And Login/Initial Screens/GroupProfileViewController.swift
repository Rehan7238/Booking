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

class GroupProfileViewController: UIViewController {
    
    //Mark: Properties
    
    var group: Group?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
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
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.groupName.text = self.group?.name
                self.addressLabel.text = self.group?.address
                self.schoolLabel.text = self.group?.school
                if let profilePicURL = self.group?.profilePic, let url = URL(string: profilePicURL) {
                    self.profilePic.downloadImage(from: url)
                }
            }
        }
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
