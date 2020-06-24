//
//  OptionToSelect.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class OptionToSelect: UITableViewCell {
    
    @IBOutlet var checkMarkImageView: UIImageView! = UIImageView()
    @IBOutlet var optionNameLabel: UILabel! = UILabel()
    @IBOutlet weak var cellView: UIView!
    
    var isOptionSelected: Bool = false
    
    func setSelected(_ value: Bool) {
        isOptionSelected = value
        if isOptionSelected {
            checkMarkImageView.isHidden = false
        } else {
            checkMarkImageView.isHidden = true
        }
    }
    
    func setName(_ name: String) {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 1
        self.optionNameLabel.text = name
    }
}
