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
 import FSCalendar
 
 class createEventView: UIViewController {
    
    @IBOutlet var eventNameText: UITextField! = UITextField()
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    
    var group: Group?
    var parentView: GroupCalendarViewController?
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        if let eventName = eventNameText.text, !eventName.isEmpty, let selectedDate = calendarView.selectedDate {
            
            let identifier = UUID()
            let event = Event.createNew(withID: "\(String(describing: identifier ))")
            event.setEventName(eventName)
            
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            let dateString = df.string(from: selectedDate)
            
            event.setDate(dateString)
            
            if let uid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: uid).done { loadedGroup in
                    if let loadedGroup = loadedGroup {
                        self.group = loadedGroup
                        event.setHostID(loadedGroup.id)
                        event.setHostName(loadedGroup.name)
                        event.setSchool(loadedGroup.school)
                        
                        self.parentView?.refreshData(selectedDate)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
 }
