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
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var corneredView: UIView!
    @IBOutlet weak var makePaymentLabel: UILabel!
    
    var request: Request?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventNameLabel.text = ""
        statusLabel.text = ""
        dateLabel.text = ""
    }
    
    func setup(requestID: String) {
        
        //shadowView.layer.cornerRadius = 10
        corneredView.layer.cornerRadius = corneredView.layer.frame.height / 5
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        profilePic.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        profilePic.layer.borderWidth = 1.0
        makePaymentLabel.isHidden = !makePaymentLabel.isHidden


        
        _ = Request.fromID(id: requestID).done { [self] loadedRequest in
            if let loadedRequest = loadedRequest {
                self.request = loadedRequest
                self.eventNameLabel.text = loadedRequest.DJName
                self.statusLabel.text = loadedRequest.status
                let status = loadedRequest.status
                if (status == "accepted") {
                    self.statusIcon.image = UIImage(named: "acceptedIcon")
                    self.makePaymentLabel.isHidden = !self.makePaymentLabel.isHidden
                }
                else if (status == "declined") {
                    self.statusIcon.image = UIImage(named: "declinedIcon")
                }
                else if (status == "open") {
                    self.statusIcon.image = UIImage(named: "pendingIcon")
                }
//                self.dateLabel.text = loadedRequest.date
                self.dateLabel.text = loadedRequest.eventName
                _ = DJ.fromID(id: loadedRequest.DJID).done { DJ in
                    if let url = URL(string: DJ?.profilePic ?? "") {
                        self.profilePic.downloadImage(from: url)
                    }
                }
            }
        }
    }
}
