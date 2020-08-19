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
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var djLabel: UILabel!
    var event: Event?
    var group: Group?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        groupNameLabel.text = ""
        dateLabel.text = ""
        djLabel.text = ""
    }
    
    func setup(eventID: String) {
        
        //shadowView.layer.cornerRadius = 10

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
            print ("MADE IT HERE")
            let groupID = loadedEvent?.hostID
            print ("HOST ID", loadedEvent?.hostID)
            _ = Group.fromID(id: groupID!).done { loadedGroup in
                self.group = loadedGroup
                if let profilePic = self.group?.profilePic, !profilePic.isEmpty {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    
                }
            }
            
        }
    }
}
