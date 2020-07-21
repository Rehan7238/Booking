 //
 //  checkRequestStatusAcceptedGroup.swift
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
 
 class checkRequestStatusAcceptedGroup: UIViewController {
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DJNameLabel: UILabel!
    

    var request: Request?
    var event: Event?
    var parentView: GroupProfileViewController?
    var DJparentView: DJProfileViewController?

    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setup(uid: String) {
        self.uid = uid
        if let uid = self.uid {
            _ = Request.fromID(id: uid).done { loadedRequest in
                self.request = loadedRequest
                self.DJNameLabel.text = loadedRequest?.DJName
                self.dateLabel.text = loadedRequest?.date
                _ = Event.fromID(id: self.request!.eventID).done { loadedEvent in
                self.event = loadedEvent
                    self.eventNameLabel.text = self.event?.eventName            }
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
