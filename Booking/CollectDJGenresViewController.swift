//
//  CollectDJGenresViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/19/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class CollectDJGenresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    @IBOutlet weak var optionsTable: UITableView!
    
    let options: [String] = ["EDM", "Alternate", "Rap", "Hip-Hop", "Classical :)", "Swag", "Test", "Something else"]
    var numberOfSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTable.dataSource = self
        optionsTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionToSelect
        cell.setName(options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let selectedChatCell = tableView.cellForRow(at: indexPath) as? OptionToSelect {
            if selectedChatCell.isOptionSelected {
                numberOfSelected -= 1
            } else {
                numberOfSelected += 1
            }
            
            selectedChatCell.setSelected(!selectedChatCell.isOptionSelected)
        }
    }
}
