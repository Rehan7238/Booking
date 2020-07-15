 //
 //  checkRequestStatusCounter.swift
 //  Booking
 //
 //  Created by Eimara Mirza on 6/23/20.
 //  Copyright © 2020 Rehan. All rights reserved.
 //
 
 import Foundation
 import UIKit
 import Firebase
 import FirebaseDatabase
 import FSCalendar
 
 class checkRequestStatusCounter: UIViewController {
    
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DJNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var request: Request?
    var parentView: GroupProfileViewController?
    var DJparentView: DJProfileViewController?
    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(uid: String) {
        self.uid = uid
        _ = Request.fromID(id: uid).done { loadedRequest in
            if let loadedRequest = loadedRequest {
                self.request = loadedRequest
                self.eventNameLabel.text = loadedRequest.eventName
                self.DJNameLabel.text = loadedRequest.DJName
                self.dateLabel.text = loadedRequest.date
                if loadedRequest.counteringParty == "group"{
                    self.messageLabel.text = "You countered " + loadedRequest.counterFee
                }
                else if loadedRequest.counteringParty == "DJ"{
                    self.messageLabel.text = loadedRequest.DJName + "  countered " + loadedRequest.counterFee
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
      
                    self.dismiss(animated: true, completion: nil)                    
                }
 }