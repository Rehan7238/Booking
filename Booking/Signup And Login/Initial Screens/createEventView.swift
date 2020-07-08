 //
 //  createEventView.swift
 //  Booking
 //
 //  Created by Eimara Mirza on 6/23/20.
 //  Copyright © 2020 Rehan. All rights reserved.
 //
 
 import Foundation
 import UIKit
 import Firebase
 import FirebaseDatabase
 
 class createEventView: UIViewController {
    
    @IBOutlet var eventNameText: UITextField! = UITextField()
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var cancelButton: UIButton!
    
    var group: Group?
    var parentView: GroupCalendarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        let identifier = UUID()
        let event = Event.createNew(withID: "\(String(describing: identifier ))")
        if let text = self.eventNameText.text {
            event.setEventName(text)
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                event.setHostID(loadedGroup!.id)
                event.setHostName(loadedGroup!.name)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        parentView?.refreshData()
    }
 }
