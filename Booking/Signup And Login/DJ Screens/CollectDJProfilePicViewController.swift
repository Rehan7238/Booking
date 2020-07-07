//
//  CollectDJProfilePicViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/19/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage


class CollectDJProfilePicViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var selectedImage: UIImage?
    var uid: String = ""
    var dj: DJ?
    
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
                    //let pathString = downloadURL.path // String
                    self.dj?.setProfilepic(downloadURL.absoluteString)
                }
            }
        }
        // Go to the next screen
        self.performSegue(withIdentifier: "toDJFinalNotes", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        _ = DJ.fromID(id: uid).done { djThatItLoaded in
            self.dj = djThatItLoaded
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollectDJProfilePicViewController.handleSelectProfile))
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CollectDJProfilePicViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectedImage = image
            profilePic.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
}





