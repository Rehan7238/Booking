//
//  EventSelectionCell.swift
//  Booking
//
//  Created by Humayun Chaudhry on 7/17/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class EventSelectionCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    var checkMarkIsHidden = true
    
    func setup(eventUID: String) {
        _ = Event.fromID(id: eventUID).done { loadedEvent in
            if let event = loadedEvent {
                self.eventNameLabel.text = event.eventName
                self.eventDateLabel.text = event.date
            }
        }
    }
    
    func setCheckMarkVisibility(visible: Bool) {
        checkMarkIsHidden = !visible
        checkMarkImage.isHidden = !visible
    }
}
