//
//  ViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var upcomingShowsTable: UITableView!
    @IBOutlet weak var previousShowsTable: UITableView!
    @IBOutlet weak var highlightsView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = DJ.fromID(id: "aNCu8ijFlYKbtJhK6MR4").done { dj in
            self.djNameLabel.text = dj.name
            self.cityAndStateLabel.text = dj.city + ", " + dj.state
            self.ratingLabel.text = "\(dj.rating)"
        }
    }
}

