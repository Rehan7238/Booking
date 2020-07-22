//
//  StatusNotificationItem.swift
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

class StatusNotificationItem {
    
    var id: String = ""
    var statusName: String = ""
    var DJID: String = ""
    var hostID: String = ""
    var requestID: String = ""


    
    func setStatusName(_ newValue: String) {
        self.statusName = newValue
        updateValue(fieldName: "statusName", newValue: newValue)
    }
    
    func setRequestName(_ newValue: String) {
           self.requestID = newValue
           updateValue(fieldName: "requestID", newValue: newValue)
       }
    
    func setDJID(_ newValue: String) {
        self.DJID = newValue
        updateValue(fieldName: "DJID", newValue: newValue)
    }
    
 
    func setHostID(_ newValue: String) {
        self.hostID = newValue
        updateValue(fieldName: "hostID", newValue: newValue)
    }
    

    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let statusNotificationItem = db.collection("StatusNotificationItem").document(id)
        statusNotificationItem.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<StatusNotificationItem?> {
        let (promise, resolver) = Promise<StatusNotificationItem?>.pending()
        
        let db = Firestore.firestore()
        let statusNotificationItems = db.collection("StatusNotificationItem").document(id)
        
        statusNotificationItems.getDocument { (document, err) in
            let statusNotificationItem = StatusNotificationItem()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    statusNotificationItem.id = document.documentID
                    statusNotificationItem.statusName = data["statusName"] as! String
                    statusNotificationItem.DJID = data["DJID"] as! String
                    statusNotificationItem.hostID = data["hostID"] as! String
                    statusNotificationItem.requestID = data["requestID"] as! String

                }
                resolver.fulfill(statusNotificationItem)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }

        }
        return promise
    }
    
    static func createNew(withID statusNotificationItemID: String) -> StatusNotificationItem {
        let db = Firestore.firestore()
        let statusNotificationItems = db.collection("StatusNotificationItem")

        let newStatusNotificationItems = StatusNotificationItem()
        newStatusNotificationItems.id = statusNotificationItemID
        
        statusNotificationItems.document(statusNotificationItemID).setData([
            "statusName": newStatusNotificationItems.statusName,
            "DJID": newStatusNotificationItems.DJID,
            "hostID": newStatusNotificationItems.hostID,
            "requestID": newStatusNotificationItems.hostID,


        ])
        
        return newStatusNotificationItems
    }
}
