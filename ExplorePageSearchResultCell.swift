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
    
    @IBOutlet var profilePicLeft: UIImageView!
    @IBOutlet var backgroundViewLeft: UIView!
    @IBOutlet var nameLabelLeft: UILabel!
    @IBOutlet var locationLabelLeft: UILabel!
    @IBOutlet var feeLabelLeft: UILabel!
    @IBOutlet var percentMatchLabelLeft: UILabel!
    
    @IBOutlet var profilePicRight: UIImageView!
    @IBOutlet var backgroundViewRight: UIView!
    @IBOutlet var nameLabelRight: UILabel!
    @IBOutlet var locationLabelRight: UILabel!
    @IBOutlet var feeLabelRight: UILabel!
    @IBOutlet var percentMatchLabelRight: UILabel!
    
    var djLeft: DJ?
    var djRight: DJ?

    func setupLeft(dj: DJ) {
        profilePicLeft.isHidden = false
        backgroundViewLeft.isHidden = false
        nameLabelLeft.isHidden = false
        locationLabelLeft.isHidden = false
        feeLabelLeft.isHidden = false
        percentMatchLabelLeft.isHidden = false
        
        profilePicLeft.layer.cornerRadius = profilePicLeft.layer.bounds.height / 2
        profilePicLeft.layer.borderColor = UIColor.green.cgColor
        profilePicLeft.layer.borderWidth = 1
        profilePicLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedLeft(_:))))
        
        backgroundViewLeft.layer.cornerRadius = 10
        backgroundViewLeft.layer.borderColor = UIColor.white.cgColor
        backgroundViewLeft.layer.borderWidth = 1
        backgroundViewLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedLeft(_:))))

        
        self.djLeft = dj
        self.nameLabelLeft.text = dj.name
        self.locationLabelLeft.text = dj.location
        self.feeLabelLeft.text = "$" + "\(String(describing: dj.playingFee))"

        if !dj.profilePic.isEmpty {
            self.profilePicLeft.downloadImage(from: URL(string: dj.profilePic)!)
        }
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                if let group = loadedGroup {
                    self.calculatePercentMatch(dj: dj, group: group, label: self.percentMatchLabelLeft)
                }
            }
        }
    }
    
    @objc func clickedLeft(_ sender: UITapGestureRecognizer) {
        let selectedDJid = djLeft?.id
        
        if let viewController = UIStoryboard(name: "SideMain", bundle: nil).instantiateViewController(identifier: "DJProfileForGroupViewController") as? DJProfileForGroupViewController {
            viewController.DJUID = selectedDJid
            self.superview?.parentContainerViewController()?.present(viewController, animated: true, completion: nil)
        }
    }

    func hideLeft() {
        profilePicLeft.isHidden = true
        backgroundViewLeft.isHidden = true
        nameLabelLeft.isHidden = true
        locationLabelLeft.isHidden = true
        feeLabelLeft.isHidden = true
        percentMatchLabelLeft.isHidden = true
    }
    
    func setupRight(dj: DJ) {
        profilePicRight.isHidden = false
        backgroundViewRight.isHidden = false
        nameLabelRight.isHidden = false
        locationLabelRight.isHidden = false
        feeLabelRight.isHidden = false
        percentMatchLabelRight.isHidden = false
        
        profilePicRight.layer.cornerRadius = profilePicRight.layer.bounds.height / 2
        profilePicRight.layer.borderColor = UIColor.green.cgColor
        profilePicRight.layer.borderWidth = 1
        profilePicRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedRight(_:))))

        backgroundViewRight.layer.cornerRadius = 10
        backgroundViewRight.layer.borderColor = UIColor.white.cgColor
        backgroundViewRight.layer.borderWidth = 1
        backgroundViewRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedRight(_:))))

        
        self.djRight = dj
        self.nameLabelRight.text = dj.name
        self.locationLabelRight.text = dj.location
        self.feeLabelRight.text = "$" + "\(String(describing: dj.playingFee))"

        if !dj.profilePic.isEmpty {
            self.profilePicRight.downloadImage(from: URL(string: dj.profilePic)!)
        }
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                if let group = loadedGroup {
                    self.calculatePercentMatch(dj: dj, group: group, label: self.percentMatchLabelRight)
                }
            }
        }
    }
    
    @objc func clickedRight(_ sender: UITapGestureRecognizer) {

        let selectedDJid = djRight?.id
        
        if let viewController = UIStoryboard(name: "SideMain", bundle: nil).instantiateViewController(identifier: "DJProfileForGroupViewController") as? DJProfileForGroupViewController {
            viewController.DJUID = selectedDJid
            self.superview?.parentContainerViewController()?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func hideRight() {
        profilePicRight.isHidden = true
        backgroundViewRight.isHidden = true
        nameLabelRight.isHidden = true
        locationLabelRight.isHidden = true
        feeLabelRight.isHidden = true
        percentMatchLabelRight.isHidden = true
    }
    
    func calculatePercentMatch(dj: DJ, group: Group, label: UILabel) {
        
        var totalScore: CGFloat = 0
        
        var itemCount = 0
        for item in group.equipment {
            if dj.equipment.contains(item) {
                itemCount += 1
            }
        }
        let equipmentScore = CGFloat(itemCount)/CGFloat(group.equipment.count)
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
                            
                            label.text = "\(Int(round(totalScore)))%"

                            if totalScore >= 90 {
                                label.textColor = UIColor.yellow
                            }
                        } else {
                            let average = (djcord.distance(to: groupcord) * 0.00062137 + 15) / 2.0
                            var locationScore = 1 - CGFloat(abs(djcord.distance(to: groupcord) * 0.00062137 - 15) / average)
                            if locationScore < 0 {
                                locationScore = 0
                            }
                            totalScore += locationScore * 33.33
                            
                           label.text = "\(Int(round(totalScore)))%"
                            if totalScore >= 90 {
                                label.textColor = UIColor.yellow
                            }
                        }
                    } else {
                        label.text = "\(Int(round(totalScore)))%"

                        if totalScore >= 90 {
                            label.textColor = UIColor.yellow
                        }
                    }
                }
            } else {
                label.text = "\(Int(round(totalScore)))%"

                if totalScore >= 90 {
                    label.textColor = UIColor.yellow
                }
            }
        }
    }
}
