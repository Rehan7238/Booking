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

class DJProfileViewController: UIViewController {
    
    //Mark: Properties
    
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var dj: DJ?
        
    
override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                if let profilePic = self.dj?.profilePic {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
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
