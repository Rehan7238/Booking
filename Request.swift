//
//  Request.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/16/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class Request {
    
    var id: String = ""
    var eventID: String = ""
    var eventName: String = "Event Name"
    var address: String = ""
    var school: String = ""
    var paymentStatus: Bool = false
    var DJID: String = ""
    var DJName: String = ""
    var date: String = ""
    var hostID: String = ""
    var hostName: String = ""
    var status: String = ""
    var originalFee: String = ""
    var counterFee: String = ""
    var counteringParty: String = ""


    func setEventName(_ newValue: String) {
        self.eventName = newValue
        updateValue(fieldName: "eventName", newValue: newValue)
    }
    
    func setEventID(_ newValue: String) {
        self.eventID = newValue
        updateValue(fieldName: "eventID", newValue: newValue)
    }
    
    func setAddress(_ newValue: String) {
        self.address = newValue
        updateValue(fieldName: "address", newValue: newValue)
    }
    
    func setSchool(_ newValue: String) {
        self.school = newValue
        updateValue(fieldName: "school", newValue: newValue)
    }
    
    func setPaymentStatus(_ newValue: Bool) {
        self.paymentStatus = newValue
        updateValue(fieldName: "paymentStatus", newValue: newValue)
    }
    
    func setDJID(_ newValue: String) {
        self.DJID = newValue
        updateValue(fieldName: "DJID", newValue: newValue)
    }
    
    func setDJName(_ newValue: String) {
        self.DJName = newValue
        updateValue(fieldName: "DJName", newValue: newValue)
    }
    
    func setStatus(_ newValue: String) {
        self.status = newValue
        updateValue(fieldName: "status", newValue: newValue)
    }
    
    func setOriginalFee(_ newValue: String) {
        self.originalFee = newValue
        updateValue(fieldName: "originalFee", newValue: newValue)
    }
    
    func setCounterFee(_ newValue: String) {
        self.counterFee = newValue
        updateValue(fieldName: "counterFee", newValue: newValue)
    }
    
    func setCounteringParty(_ newValue: String) {
        self.counteringParty = newValue
        updateValue(fieldName: "counteringParty", newValue: newValue)
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
        let event = db.collection("Requests").document(id)
        event.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Request?> {
        let (promise, resolver) = Promise<Request?>.pending()
        
        let db = Firestore.firestore()
        let requests = db.collection("Requests").document(id)
        
        requests.getDocument { (document, err) in
            let request = Request()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    request.id = document.documentID
                    request.eventName = data["eventName"] as! String
                    request.eventID = data["eventID"] as! String
                    request.address = data["address"] as! String
                    request.paymentStatus = data["paymentStatus"] as! Bool
                    request.DJID = data["DJID"] as! String
                    request.DJName = data["DJName"] as! String
                    request.date = data["date"] as! String
                    request.hostID = data["hostID"] as! String
                    request.hostName = data["hostName"] as! String
                    request.school = data["school"] as! String
                    request.status = data["status"] as! String
                    request.originalFee = data["originalFee"] as! String
                    request.counterFee = data["counterFee"] as! String
                    request.counteringParty = data["counteringParty"] as! String

                }
                resolver.fulfill(request)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
        }
        return promise
    }
    
    static func createNew(withID requestID: String) -> Request {
        let db = Firestore.firestore()
        let requests = db.collection("Requests")

        let newRequest = Request()
        newRequest.id = requestID
        
        requests.document(requestID).setData([
            "eventName": newRequest.eventName,
            "eventID": newRequest.eventID,
            "address": newRequest.address,
            "paymentStatus": newRequest.paymentStatus,
            "status": newRequest.status,
            "DJID": newRequest.DJID,
            "DJName": newRequest.DJName,
            "date": newRequest.date,
            "hostID": newRequest.hostID,
            "hostName": newRequest.hostName,
            "school": newRequest.school,
            "originalFee": newRequest.originalFee,
            "counterFee": newRequest.counterFee,
            "counteringParty": newRequest.counteringParty
        ])
        
        return newRequest
    }
}
