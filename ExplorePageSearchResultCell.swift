//
//  ExplorePageSearchResultCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 7/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import FirebaseAuth
import GooglePlaces
import UIKit
import CoreLocation

class ExplorePageSearchResultCell: UITableViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var percentMatchLabel: UILabel!
    
    var dj: DJ?
    
    func setup(djID: String) {
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 6
        requestButton.layer.cornerRadius = profilePic.layer.bounds.height / 5

        _ = DJ.fromID(id: djID).done { loadedDJ in
            self.dj = loadedDJ
            self.nameLabel.text = loadedDJ?.name
            self.locationLabel.text = loadedDJ?.location
            self.feeLabel.text = "$" + "\(String(describing: self.dj?.playingFee ?? 0))"

            if let profile = loadedDJ?.profilePic, !profile.isEmpty {
                self.profilePic.downloadImage(from: URL(string: profile)!)
            }
            if let uid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: uid).done { loadedGroup in
                    if let dj = loadedDJ, let group = loadedGroup {
                        self.calculatePercentMatch(dj: dj, group: group)
                    }
                }
            }
        }
    }
    
    func calculatePercentMatch(dj: DJ, group: Group) {
        var totalScore: CGFloat = 0
        
        var itemCount = 0
        for item in group.equipment {
            if dj.equipment.contains(item) {
                itemCount += 1
            }
        }
        let equipmentScore = CGFloat(itemCount/group.equipment.count)
        totalScore += equipmentScore * 33.33
        
        var priceScore: CGFloat = 0
        if dj.playingFee.doubleValue >= group.lowerPrice.doubleValue && dj.playingFee.doubleValue <= group.higherPrice.doubleValue {
            priceScore = 1.00
        } else {
            if abs(dj.playingFee.doubleValue - group.lowerPrice.doubleValue) < abs(dj.playingFee.doubleValue - group.higherPrice.doubleValue) {
                let average: Double = (dj.playingFee.doubleValue + group.lowerPrice.doubleValue) / 2.0
                priceScore = 1 - CGFloat(abs(dj.playingFee.doubleValue - group.lowerPrice.doubleValue) / average)
                if priceScore < 0 {
                    priceScore = 0
                }
            } else {
                let average = (dj.playingFee.doubleValue + group.higherPrice.doubleValue) / 2.0
                priceScore = 1 - CGFloat(abs(dj.playingFee.doubleValue - group.higherPrice.doubleValue) / average)
                if priceScore < 0 {
                    priceScore = 0
                }
            }
        }
        totalScore += priceScore * 33.33
        
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(dj.location) {
            placemarks, error in
            let placemark = placemarks?.first
            if let djcord = placemark?.location?.coordinate {
                geocoder.geocodeAddressString(group.address) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    if let groupcord = placemark?.location?.coordinate {
                        if djcord.distance(to: groupcord) * 0.00062137 < 15 {
                            totalScore += 33.33
                            
                            self.percentMatchLabel.text = "\(Int(round(totalScore)))% Match"

                            if totalScore >= 90 {
                                self.percentMatchLabel.textColor = UIColor.yellow
                            }
                        } else {
                            let average = (djcord.distance(to: groupcord) * 0.00062137 + 15) / 2.0
                            var locationScore = 1 - CGFloat(abs(djcord.distance(to: groupcord) * 0.00062137 - 15) / average)
                            if locationScore < 0 {
                                locationScore = 0
                            }
                            totalScore += locationScore * 33.33
                            
                            self.percentMatchLabel.text = "\(Int(round(totalScore)))% Match"
                            if totalScore >= 90 {
                                self.percentMatchLabel.textColor = UIColor.yellow
                            }
                        }
                    } else {
                        self.percentMatchLabel.text = "\(Int(round(totalScore)))% Match"

                        if totalScore >= 90 {
                            self.percentMatchLabel.textColor = UIColor.yellow
                        }
                    }
                }
            } else {
                self.percentMatchLabel.text = "\(Int(round(totalScore)))% Match"

                if totalScore >= 90 {
                    self.percentMatchLabel.textColor = UIColor.yellow
                }
            }
        }
    }
}
