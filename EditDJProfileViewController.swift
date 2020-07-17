//
//  EditDJProfileViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/8/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField


class EditDJProfileViewController: UIViewController, UITextFieldDelegate {
    
    var dj: DJ?
    var uid: String = ""
    var selectedImage: UIImage?



    
    //MARK: Properties
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var playingFeeTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var playlistLinkTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var instagramLinkTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let uid = Auth.auth().currentUser?.uid {
                   _ = DJ.fromID(id: uid).done { loadedDJ in
                       self.dj = loadedDJ
            
                    self.nameTextField.text = self.dj?.name
                    self.playingFeeTextField.text = "\(String(describing: self.dj?.playingFee ?? 0))"
                    self.instagramLinkTextField.text = self.dj?.instagramLink
                    self.playlistLinkTextField.text = self.dj?.playlist

            }
                   }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollectDJProfilePicViewController.handleSelectProfile))
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2;
        profilePic.clipsToBounds = true;
        profilePic.layer.borderWidth = 0;
        profilePic.addGestureRecognizer(tapGesture)
        profilePic.isUserInteractionEnabled = true
        
               
        nameTextField.delegate = self
        playingFeeTextField.delegate = self
        instagramLinkTextField.delegate = self
        playlistLinkTextField.delegate = self

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedApplyChanges(_sender: Any){
           if let uid = Auth.auth().currentUser?.uid {
               self.uid = uid
           }
        
        
        self.dj?.setName(self.nameTextField.text!)
    
        if let value = playingFeeTextField.text, !value.isEmpty {
            self.dj?.setPlayingFee(NSNumber.init(value: Int32(value)!))
        };
        
        if let instaLINK = instagramLinkTextField.text, !instaLINK.isEmpty {
            self.dj?.setInstagramLink(instaLINK)
        };
        if let playlistLINK = playlistLinkTextField.text, !playlistLINK.isEmpty {
            self.dj?.setPlaylist(playlistLINK)
        };

           
        
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
                       self.dj?.setProfilepic(downloadURL.absoluteString)
                   }
               }
           }
                self.dismiss(animated: true, completion: nil)

       }
       

}
