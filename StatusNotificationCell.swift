//
//  StatusNotificationCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 7/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class StatusNotificationCell: UITableViewCell {
    
    @IBOutlet var statustext: UILabel!
    @IBOutlet var picture: UIImageView!
    
    var statusNotificationItem: StatusNotificationItem?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statustext.text = ""
    }
    
    func setup(statusNotificationItemID: String) {
        
        //shadowView.layer.cornerRadius = 10
        //profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        _ = StatusNotificationItem.fromID(id: statusNotificationItemID).done { loadedItem in
            if let loadedItem = loadedItem {
                self.statusNotificationItem = loadedItem
                self.statustext.text = loadedItem.statusName
            }
        }
    }
}
