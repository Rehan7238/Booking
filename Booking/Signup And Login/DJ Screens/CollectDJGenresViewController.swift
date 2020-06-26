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
    @IBOutlet weak var nextButton: UIButton!
    
    let options: [String] = ["EDM", "Alternate", "Rap", "Hip-Hop", "Classical :)", "Swag", "Test", "Something else"]
    var genreList: [String] = []
    var dj: DJ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: uid).done { dj in
                if dj != nil {
                    self.dj = dj
                }
            }
        }
        
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
                if let index = genreList.firstIndex(of: selectedChatCell.optionNameLabel.text!) {
                    genreList.remove(at: index)
                }
            } else {
                genreList.append(selectedChatCell.optionNameLabel.text!)
            }
            
            
            selectedChatCell.setSelected(!selectedChatCell.isOptionSelected)
        }
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.dj?.setMusicStyle(genreList)
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
}
