//
//  CollectGroupEquipmentViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth

class CollectGroupEquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Mark: Properties
    
    @IBOutlet weak var optionsTable:
    UITableView!
    
    let options: [String] = ["Stereos", "Speakers", "Microphone", "Lights", "Magic Potion", "Something else idk"]
    var numberOfSelected = 0
    var group: Group?
    
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
        var equipmentList = [String]()
        
        if let selectedChatCell = tableView.cellForRow(at: indexPath) as? OptionToSelect {
            if selectedChatCell.isOptionSelected {
                numberOfSelected -= 1
                equipmentList.append(selectedChatCell.optionNameLabel.text!)
            } else {
                numberOfSelected += 1
            }
            
            selectedChatCell.setSelected(!selectedChatCell.isOptionSelected)
        }
    }
    
}
