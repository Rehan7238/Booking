//
//  InviteContactsCell.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/24/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class InviteContactsCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var contactsVC: InviteContactsViewController?
    
    func setup(_ contactsVC: InviteContactsViewController, friendName: String, phoneNumber: String, userType: String, isActiveUser: Bool) {
        self.contactsVC = contactsVC
        friendNameLabel.text = friendName
        userTypeLabel.text = userType
        phoneNumberLabel.text = phoneNumber
        
        if isActiveUser {
            actionButton.setTitle("Invite to X O X O", for: .normal)
        } else {
            
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        self.contactsVC?.displayMessageInterface(recipient: phoneNumberLabel.text ?? "")
    }
}
