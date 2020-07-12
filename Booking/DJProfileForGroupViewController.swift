//
//  DJProfileForGroupViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/11/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField;
import GooglePlaces
import PromiseKit
import Firebase


class DJProfileForGroupViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var DJRatingNumber: UILabel!
    @IBOutlet weak var numberOfGigsNumber: UILabel!
    
    var dj: DJ?
            
        
    override func viewDidLoad() {
            super.viewDidLoad()
            
            profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
            
            requestButton.layer.cornerRadius = requestButton.frame.height / 5

            if let uid = Auth.auth().currentUser?.uid {
                _ = DJ.fromID(id: uid).done { loadedDJ in
                    self.dj = loadedDJ
                    self.djName.text = self.dj?.name
                    if let profilePic = self.dj?.profilePic {
                        self.profilePic.downloadImage(from: URL(string: profilePic)!)
                        var calculatedRating = 0
                        let ratings = self.dj?.hostRating
                        for rating in ratings!{
                            calculatedRating = calculatedRating + Int(truncating: rating)
                        }
                        self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings!.count))"
                        self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                    }
                }
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
                   profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
                   
                   
                   if let uid = Auth.auth().currentUser?.uid {
                       _ = DJ.fromID(id: uid).done { loadedDJ in
                           self.dj = loadedDJ
                           self.djName.text = self.dj?.name
                        var calculatedRating = 0
                        let ratings = self.dj?.hostRating
                        for rating in ratings!{
                            calculatedRating = calculatedRating + Int(truncating: rating)
                        }
                        self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings!.count))"
                        self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                        
                           if let profilePic = self.dj?.profilePic {
                               self.profilePic.downloadImage(from: URL(string: profilePic)!)
                           }
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
    }
