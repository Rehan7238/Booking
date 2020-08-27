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
import EHHorizontalSelectionView

class ExplorePageSearchResultCell: EHHorizontalLineViewCell {
    
    @IBOutlet var profilePic: UIImageView! = UIImageView()
    @IBOutlet var backgroundCustomView: UIView! = UIView()
    @IBOutlet var nameLabel: UILabel! = UILabel()
    @IBOutlet var locationLabel: UILabel! = UILabel()
    @IBOutlet var feeLabel: UILabel! = UILabel()
    @IBOutlet var percentMatchLabel: UILabel! = UILabel()
    @IBOutlet var ratingLabel: UILabel! = UILabel()
    @IBOutlet var style: UILabel! = UILabel()
    
    var dj: DJ?

    func setup(dj: DJ) {

        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clicked(_:))))
        backgroundCustomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clicked(_:))))

        self.dj = dj
        self.nameLabel.text = dj.name
        self.locationLabel.text = dj.location
        self.feeLabel.text = "$" + "\(String(describing: dj.playingFee))"
        self.ratingLabel.text = "\(dj.getRating())"
        
        backgroundCustomView.layer.shadowColor = UIColor.black.cgColor
        backgroundCustomView.layer.shadowOpacity = 0.7
        backgroundCustomView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundCustomView.layer.shadowRadius = 4
        
        var totalMusicGenre = ""
        for musicGenre in dj.musicStyle {
            totalMusicGenre += musicGenre + ", "
        }
        if totalMusicGenre.hasSuffix(", ") {
            totalMusicGenre = String(totalMusicGenre.dropLast(2))
        }
        self.style.text = totalMusicGenre

        if !dj.profilePic.isEmpty {
            self.profilePic.downloadImage(from: URL(string: dj.profilePic)!)
        }
    }
    
    @objc func clicked(_ sender: UITapGestureRecognizer) {
        let selectedDJid = dj?.id
        
        if let viewController = UIStoryboard(name: "SideMain", bundle: nil).instantiateViewController(identifier: "DJProfileForGroupViewController") as? DJProfileForGroupViewController {
            viewController.DJUID = selectedDJid
            self.superview?.parentContainerViewController()?.present(viewController, animated: true, completion: nil)
        }
    }
}
