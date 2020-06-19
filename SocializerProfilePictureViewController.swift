//
//  SocializerProfilePictureViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/18/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class SocializerProfilePictureViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedImage: UIImage?
    var uid: String = ""

    @IBAction func pressedNextButton(_sender: Any){
        if let uid = Auth.auth().currentUser?.uid {
            self.uid = uid
        }
        
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
              }
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SocializerProfilePictureViewController.handleSelectProfile))
        profilePic.layer.cornerRadius = 40;
        profilePic.clipsToBounds = true;
        profilePic.addGestureRecognizer(tapGesture)
        profilePic.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfile () {
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
        pickerController.delegate = self
    }
   
    
}

extension SocializerProfilePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImage = image
            profilePic.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
}
