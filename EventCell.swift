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
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    var event: Event?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        groupNameLabel.text = ""
        dateLabel.text = ""
        djLabel.text = ""
    }
    
    func setup(eventID: String) {
        
        shadowView.layer.cornerRadius = 10

        _ = Event.fromID(id: eventID).done { loadedEvent in
            self.event = loadedEvent
            self.nameLabel.text = loadedEvent?.eventName
            self.groupNameLabel.text = loadedEvent?.hostName
            self.dateLabel.text = loadedEvent?.date
            if loadedEvent?.DJBooked ?? false, let djID = loadedEvent?.DJID {
                _ = DJ.fromID(id: djID).done { loadedDJ in
                    self.djLabel.text = loadedDJ?.name
                }
            } else {
                self.djLabel.text = "DJ Not Booked"
            }
        }
    }
}
