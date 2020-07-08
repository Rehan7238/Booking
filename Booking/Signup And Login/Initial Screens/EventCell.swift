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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var event: Event?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        locationLabel.text = ""
    }
    
    func setup(eventID: String) {
        nameLabel.text = ""
        locationLabel.text = ""
        _ = Event.fromID(id: eventID).done { loadedEvent in
            self.event = loadedEvent
            self.nameLabel.text = loadedEvent?.eventName
            self.locationLabel.text = loadedEvent?.address
        }
    }
}
