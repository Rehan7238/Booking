//
//  Vendor.swift
//  Booking
//
//  Created by Eimara Mirza on 6/22/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class Vendor {
    
    var id: String = ""
       var name: String = "Name"
       var address: String = ""
    var state: String = ""
    var city: String = " "
       var equipment: [String] = []
       var futureEvents: [String] = []
       var higherPrice: NSNumber = 0.0
       var lowerPrice: NSNumber = 0.0
       var previousEvents: [String] = []
       var profilePic: String = ""
       
func setName(_ newName: String) {
           self.name = newName
           updateValue(fieldName: "name", newValue: newName)
       }
    
    
func setAddress(_ newAddress: String) {
    self.address = newAddress
    updateValue(fieldName: "address", newValue: newAddress)
}
    
func setCity(_ newCity: String) {
        self.city = newCity
        updateValue(fieldName: "city", newValue: newCity)
    }
func setState(_ newState: String) {
        self.state = newState
        updateValue(fieldName: "state", newValue: newState)
    }
    
    func setEquipment(_ newEquipment: [String]) {
        self.equipment = newEquipment
        updateValue(fieldName: "equipment", newValue: newEquipment)
    }
    
    func setFutureEvents(_ newFutureEvents: [String]) {
        self.futureEvents = newFutureEvents
        updateValue(fieldName: "futureEvents", newValue: newFutureEvents)
    }
    
    func setHigherPrice(_ newHigherPrice: NSNumber) {
        self.higherPrice = newHigherPrice
        updateValue(fieldName: "higherPrice", newValue: newHigherPrice)
    }
    
    func setLowerPrice(_ newLowerPrice: NSNumber) {
        self.lowerPrice = newLowerPrice
        updateValue(fieldName: "lowerPrice", newValue: newLowerPrice)
    }
    
    func setPreviousEvents(_ newPreviousEvents: [String]) {
        self.previousEvents = newPreviousEvents
        updateValue(fieldName: "previousEvents", newValue: newPreviousEvents)
    }
    
    func setProfilePic(_ newProfilePic: String) {
        self.profilePic = newProfilePic
        updateValue(fieldName: "profilePic", newValue: newProfilePic)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let vendor = db.collection("Vendors").document(id)
        vendor.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Vendor?> {
        let (promise, resolver) = Promise<Vendor?>.pending()
        
        let db = Firestore.firestore()
        let vendors = db.collection("Vendors").document(id)
        
        vendors.getDocument { (document, err) in
            let vendor = Vendor()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    vendor.id = document.documentID
                    vendor.name = data["name"] as! String
                    vendor.address = data["address"] as!String
                    vendor.city = data["city"] as!String
                    vendor.state = data["state"] as!String
                    vendor.equipment = data["equipment"] as! [String]
                    vendor.futureEvents = data["futureEvents"] as! [String]
                    vendor.higherPrice = data["higherPrice"] as! NSNumber
                    vendor.lowerPrice = data["lowerPrice"] as! NSNumber
                    vendor.previousEvents = data["previousEvents"] as! [String]
                    vendor.profilePic = data["profilePic"] as! String
                }
                resolver.fulfill(vendor)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
            
            
        }
        return promise
    }
    
    static func createNew(withID groupID: String) -> Vendor {
        let db = Firestore.firestore()
        let vendors = db.collection("Vendors")

        let newVendor = Vendor()
        newVendor.id = groupID
        
        vendors.document(groupID).setData([
            "name": newVendor.name,
            "address": newVendor.address,
            "equipment": newVendor.equipment,
            "futureEvents": newVendor.futureEvents,
            "higherPrice": newVendor.higherPrice,
            "lowerPrice": newVendor.lowerPrice,
            "previousEvents": newVendor.previousEvents,
            "profilePic": newVendor.profilePic
        ])
        
        return newVendor
    }
}

