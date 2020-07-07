//
//  EventCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 7/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    var event: Event?
    
    func setup(djID: String) {
        profilePic.layer.cornerRadius = profilePic.layer.bounds.height / 2
        _ = Event.fromID(id: djID).done { loadedEvent in
            self.event = loadedEvent
            self.nameLabel.text = loadedEvent?.eventName
            self.locationLabel.text = loadedEvent?.address
            
        }
    }
}
