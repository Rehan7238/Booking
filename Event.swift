//
//  Host.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/16/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import FirebaseStorage
import FirebaseFirestore

class Event {
    
    var id: String = ""
    var eventName: String = "Event Name"
    var address: String = ""
    var school: String = ""
    var DJBooked: Bool = false
    var DJID: String = ""
    var closedEvent: Bool = false
    var date: String = ""
    var hostID: String = ""
    var hostName: String = ""

    
    func setEventName(_ newValue: String) {
        self.eventName = newValue
        updateValue(fieldName: "eventName", newValue: newValue)
    }
    
    func setAddress(_ newValue: String) {
        self.address = newValue
        updateValue(fieldName: "address", newValue: newValue)
    }
    
    func setSchool(_ newValue: String) {
        self.school = newValue
        updateValue(fieldName: "school", newValue: newValue)
    }
    
    func setDJBooked(_ newValue: Bool) {
        self.DJBooked = newValue
        updateValue(fieldName: "DJBooked", newValue: newValue)
    }
    
    func setDJID(_ newValue: String) {
        self.DJID = newValue
        updateValue(fieldName: "DJID", newValue: newValue)
    }
    
    func setClosedEvent(_ newValue: Bool) {
        self.closedEvent = newValue
        updateValue(fieldName: "closedEvent", newValue: newValue)
    }
    
    func setDate(_ newValue: String) {
        self.date = newValue
        updateValue(fieldName: "date", newValue: newValue)
    }
    
    func setHostID(_ newValue: String) {
        self.hostID = newValue
        updateValue(fieldName: "hostID", newValue: newValue)
    }
    
    func setHostName(_ newValue: String) {
        self.hostName = newValue
        updateValue(fieldName: "hostName", newValue: newValue)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let event = db.collection("Events").document(id)
        event.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Event?> {
        let (promise, resolver) = Promise<Event?>.pending()
        
        let db = Firestore.firestore()
        let events = db.collection("Events").document(id)
        
        events.getDocument { (document, err) in
            let event = Event()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    event.id = document.documentID
                    event.eventName = data["eventName"] as! String
                    event.address = data["address"] as! String
                    event.DJBooked = data["DJBooked"] as! Bool
                    event.DJID = data["DJID"] as! String
                    event.closedEvent = data["closedEvent"] as! Bool
                    event.date = data["date"] as! String
                    event.hostID = data["hostID"] as! String
                    event.hostName = data["hostName"] as! String
                    event.school = data["school"] as! String



                }
                resolver.fulfill(event)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
        }
        return promise
    }
    
    static func createNew(withID eventID: String) -> Event {
        let db = Firestore.firestore()
        let events = db.collection("Events")

        let newEvent = Event()
        newEvent.id = eventID
        
        events.document(eventID).setData([
            "eventName": newEvent.eventName,
            "address": newEvent.address,
            "DJBooked": newEvent.DJBooked,
            "DJID": newEvent.DJID,
            "closedEvent": newEvent.closedEvent,
            "date": newEvent.date,
            "hostID": newEvent.hostID,
            "hostName": newEvent.hostName,
            "school": newEvent.school


        ])
        
        return newEvent
    }
}
