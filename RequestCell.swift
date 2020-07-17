//
//  RequestCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 7/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var request: Request?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventNameLabel.text = ""
        statusLabel.text = ""
        dateLabel.text = ""
    }
    
    func setup(requestID: String) {
        
        //shadowView.layer.cornerRadius = 10
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        _ = Request.fromID(id: requestID).done { loadedRequest in
            if let loadedRequest = loadedRequest {
                self.request = loadedRequest
                self.eventNameLabel.text = loadedRequest.DJName
                self.statusLabel.text = loadedRequest.status
                self.dateLabel.text = loadedRequest.date
                _ = DJ.fromID(id: loadedRequest.DJID).done { DJ in
                    if let url = URL(string: DJ?.profilePic ?? "") {
                        self.profilePic.downloadImage(from: url)
                    }
                }
            }
        }
    }
}
