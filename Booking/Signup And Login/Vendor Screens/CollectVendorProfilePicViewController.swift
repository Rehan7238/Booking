//
//  CollectVendorProfilePicViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/22/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class CollectVendorProfilePicViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: Properties
    var selectedImage: UIImage?
    var uid: String = ""
    var vendor: Vendor?
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    
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
                         let pathString = downloadURL.path // String
                         self.vendor?.setProfilePic(pathString)
                       }
                     }
                 }
             // Go to the next screen
             self.performSegue(withIdentifier: "toVendorFinalNotes", sender: self)
             }
                     
             override func viewDidLoad() {
                 super.viewDidLoad()
                 guard let uid = Auth.auth().currentUser?.uid else { return}
                 _ = Vendor.fromID(id: uid).done { groupThatItLoaded in
                     self.vendor = groupThatItLoaded
                 }
                 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollectVendorProfilePicViewController.handleSelectProfile))
                 profilePic.layer.cornerRadius = profilePic.frame.size.height/2;
                 profilePic.clipsToBounds = true;
                 profilePic.layer.borderWidth = 0;
                 profilePic.addGestureRecognizer(tapGesture)
                 profilePic.isUserInteractionEnabled = true
                 
                 
             }
             
             @objc func handleSelectProfile () {
                 let pickerController = UIImagePickerController()
                 present(pickerController, animated: true, completion: nil)
                 pickerController.delegate = self
             }
            
             
         }

     extension CollectVendorProfilePicViewController {
         
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
                 selectedImage = image
                 profilePic.image = image
                 
             }
             dismiss(animated: true, completion: nil)
         }
     }


      


