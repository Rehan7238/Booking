 //
 //  checkRequestStatusOpenDJ.swift
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
 
 class checkRequestStatusOpenDJ: UIViewController {
    
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DJNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var counterFeeTextField: UITextField!
    @IBOutlet weak var counterButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var request: Request?
    var event: Event?
    var dj: DJ?
    var group: Group?
    var DJName = ""

    var DJparentView: DJProfileViewController?

    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let DJuid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: DJuid).done { [self] loadedDJ in
                self.dj = loadedDJ
                self.DJName = loadedDJ?.name ?? ""
                
            }
        }
        
    }
    
    func setup(uid: String) {
        self.uid = uid
        if let uid = self.uid {
            _ = Request.fromID(id: uid).done { loadedRequest in
                self.request = loadedRequest
                self.eventNameLabel.text = loadedRequest?.eventName
                self.DJNameLabel.text = loadedRequest?.DJName
                self.dateLabel.text = loadedRequest?.date
                //self.eventNameLabel.text = loadedRequest?.eventName
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedAccept(_ sender: Any) {
        request?.setStatus("accepted")
        
        // notification item
        let identifier2 = UUID()
        let notificationItem = StatusNotificationItem.createNew(withID: "\(String(describing: identifier2 ))")
        ///
        
        var eventID = request?.eventID
        var DJName = ""
        var eventName = ""
        _ = Event.fromID(id: eventID!).done { loadedEvent in
        self.event = loadedEvent
            if let DJuid = Auth.auth().currentUser?.uid {
                _ = DJ.fromID(id: DJuid).done { [self]loadedDJ in
                    self.dj = loadedDJ
                    DJName = loadedDJ?.name ?? ""
                    eventName = self.event?.eventName ?? ""
                    self.event?.setDJID(DJuid)
                    self.event?.setDJBooked(true)
                    notificationItem.setDJID(DJuid)
                    notificationItem.setRequestName(self.request!.id)
                }
            }
            _ = Group.fromID(id: loadedEvent!.hostID).done {loadedGroup in
                if let loadedGroup = loadedGroup {
                    self.group = loadedGroup
                    notificationItem.setHostID(loadedGroup.id)
                    notificationItem.setRequestName(self.request!.id)
                    
                    let db = Firestore.firestore()
                    db.collection("userTokensForNotifs").getDocuments() {
                        (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if document.documentID == loadedGroup.id {
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: document.data()["fcmToken"]as! String, title: "\(DJName)accepted your request for \(eventName)!", body: "check the app")
                                }
                            }
                        }
                    }
                    var notificationList = loadedGroup.notifications
                                   notificationList.append(notificationItem.id)
                    loadedGroup.setNotifications(notificationList)
                                   notificationItem.setDJID(loadedGroup.id)
                                   notificationItem.setStatusName("\(DJName) accepted your request for\(eventName)!")
                }
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func clickedDecline(_ sender: Any) {
        request?.setStatus("declined")
        
        // notification item
        let identifier2 = UUID()
        let notificationItem = StatusNotificationItem.createNew(withID: "\(String(describing: identifier2 ))")
        ///
        
        var eventID = request?.eventID
        var DJName = ""
        var eventName = ""
        _ = Event.fromID(id: eventID!).done { loadedEvent in
        self.event = loadedEvent
            if let DJuid = Auth.auth().currentUser?.uid {
                _ = DJ.fromID(id: DJuid).done { [self]loadedDJ in
                    self.dj = loadedDJ
                    DJName = loadedDJ?.name ?? ""
                    eventName = self.event?.eventName ?? ""
                    notificationItem.setDJID(DJuid)
                    notificationItem.setRequestName(self.request!.id)
                }
            }
            _ = Group.fromID(id: loadedEvent!.hostID).done {loadedGroup in
                if let loadedGroup = loadedGroup {
                    self.group = loadedGroup
                    notificationItem.setHostID(loadedGroup.id)
                    notificationItem.setRequestName(self.request!.id)
                    
                    let db = Firestore.firestore()
                    db.collection("userTokensForNotifs").getDocuments() {
                        (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if document.documentID == loadedGroup.id {
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: document.data()["fcmToken"]as! String, title: "\(DJName)declined your request for \(eventName).", body: "check the app")
                                }
                            }
                        }
                    }
                    var notificationList = loadedGroup.notifications
                                   notificationList.append(notificationItem.id)
                    loadedGroup.setNotifications(notificationList)
                                   notificationItem.setDJID(loadedGroup.id)
                                   notificationItem.setStatusName("\(DJName) declined your request for\(eventName).")
                }
            }
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedCounter(_ sender: Any) {
        request?.setStatus("countered")
        request?.setCounterFee(counterFeeTextField.text!)
        request?.setCounteringParty("DJ")
        
        // notification item
        let identifier2 = UUID()
        let notificationItem = StatusNotificationItem.createNew(withID: "\(String(describing: identifier2 ))")
        ///
        
        var eventID = request?.eventID
        var DJName = ""
        var eventName = ""
        _ = Event.fromID(id: eventID!).done { loadedEvent in
        self.event = loadedEvent
            if let DJuid = Auth.auth().currentUser?.uid {
                _ = DJ.fromID(id: DJuid).done { [self]loadedDJ in
                    self.dj = loadedDJ
                    DJName = loadedDJ?.name ?? ""
                    eventName = self.event?.eventName ?? ""
                    notificationItem.setDJID(DJuid)
                    notificationItem.setRequestName(self.request!.id)
                }
            }
            _ = Group.fromID(id: loadedEvent!.hostID).done {loadedGroup in
                if let loadedGroup = loadedGroup {
                    self.group = loadedGroup
                    notificationItem.setHostID(loadedGroup.id)
                    notificationItem.setRequestName(self.request!.id)
                    
                    let db = Firestore.firestore()
                    db.collection("userTokensForNotifs").getDocuments() { [self]
                        (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if document.documentID == loadedGroup.id {
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: document.data()["fcmToken"]as! String, title: "\(DJName)countered your request for \(self.counterFeeTextField.text!).", body: "check the app")
                                }
                            }
                        }
                    }
                    var notificationList = loadedGroup.notifications
                                   notificationList.append(notificationItem.id)
                    loadedGroup.setNotifications(notificationList)
                                   notificationItem.setDJID(loadedGroup.id)
                    notificationItem.setStatusName("(\(DJName) accepted your request for\(self.counterFeeTextField.text!).")
                }
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 }
 
