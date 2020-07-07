//
//  ExplorePageSearchResultCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 7/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class ExplorePageSearchResultCell: UITableViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    var dj: DJ?
    
    func setup(djID: String) {
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        _ = DJ.fromID(id: djID).done { loadedDJ in
            self.dj = loadedDJ
            self.nameLabel.text = loadedDJ?.name
            self.locationLabel.text = loadedDJ?.location
            if let profile = loadedDJ?.profilePic {
                self.profilePic.downloadImage(from: URL(string: profile)!)
            }
        }
    }
}