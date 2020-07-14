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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var playingFeeLabel: UILabel!
    @IBOutlet weak var DJRatingNumber: UILabel!
    @IBOutlet weak var numberOfGigsNumber: UILabel!
    var dj: DJ?
    var group: Group?
    var DJUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 6
        requestButton.layer.cornerRadius = requestButton.frame.height / 5
        
        if let uid = self.DJUID {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                self.locationLabel.text = self.dj?.locality
                if let profilePic = self.dj?.profilePic {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    var calculatedRating = 0
                    if let ratings = self.dj?.hostRating {
                        for rating in ratings {
                            calculatedRating = calculatedRating + Int(truncating: rating)
                        }
                        if ratings.count == 0 {
                            self.DJRatingNumber.text = "N/A"
                        } else {
                            self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings.count))"
                        }
                        
                    }
                    self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                    self.playingFeeLabel.text = "$" + "\(String(describing: self.dj?.playingFee ?? 0))"

                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 6
        
        if let uid = self.DJUID {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                self.locationLabel.text = self.dj?.location
                var calculatedRating = 0
                if let ratings = self.dj?.hostRating {
                    for rating in ratings {
                        calculatedRating = calculatedRating + Int(truncating: rating)
                    }
                    if ratings.count == 0 {
                        self.DJRatingNumber.text = "N/A"
                    } else {
                        self.DJRatingNumber.text = "\(String(describing: calculatedRating/ratings.count))"
                    }
                    
                }
                self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                
                if let profilePic = self.dj?.profilePic {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                }
                self.playingFeeLabel.text = "$" + "\(String(describing: self.dj?.playingFee ?? 0))"

            }
        }
    }
    
    @IBAction func createEventClicked(_ sender: Any) {

        if let createRequestVC = Bundle.main.loadNibNamed("createRequestView", owner: nil, options: nil)?.first as? createRequestView {
            createRequestVC.DJUID = DJUID
            createRequestVC.parentView = self
            self.present(createRequestVC, animated: true, completion: nil)
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
