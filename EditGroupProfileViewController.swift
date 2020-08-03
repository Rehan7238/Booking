//
//  EditGroupProfileViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/8/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseStorage
import SkyFloatingLabelTextField


class EditGroupProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyChangesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var groupNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    var group: Group?
    var uid: String = ""
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                
                self.groupNameTextField.text = self.group?.name
                
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollectDJProfilePicViewController.handleSelectProfile))
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2;
        profilePic.clipsToBounds = true;
        profilePic.layer.borderWidth = 0;
        profilePic.addGestureRecognizer(tapGesture)
        profilePic.isUserInteractionEnabled = true
        
        
        groupNameTextField.delegate = self
        
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedApplyChanges(_sender: Any){
        if let uid = Auth.auth().currentUser?.uid {
            self.uid = uid
        }
        
        
        self.group?.setName(self.groupNameTextField.text!)
        
        // For the Profile Picture
        let storageRef = Storage.storage().reference(forURL:"gs://djbooking-f3a55.appspot.com").child("profile_image").child(uid)
        
        if let profileImg = self.selectedImage ,let imageData = profileImg.jpegData(compressionQuality: 0.1){
            
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    //let pathString = downloadURL.path // String
                    self.group?.setProfilePic(downloadURL.absoluteString)
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

