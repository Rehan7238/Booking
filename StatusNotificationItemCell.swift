//
//  StatusNotificationItemCell.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class StatusNotificationItemCell: UITableViewCell {
  func updateWithNewsItem(_ item: StatusNotificationItem) {
    textLabel?.text = item.title
  }
}
