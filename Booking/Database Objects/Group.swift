//
//  Group.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import GooglePlaces


class Group {
    
    var id: String = ""
    var school: String = ""
   // var schoolGeoPoint:  GeoPoint? = nil
    var schoolLongitude:  String = ""
    var schoolLatitude:  String = ""
    var name: String = "Name"
    var address: String = ""
    var city: String = ""
    var state: String =  ""
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
    
    func setLongitude(_ newAddress: String) {
        self.schoolLongitude = newAddress
        updateValue(fieldName: "schoolLongitude", newValue: newAddress)
    }
    
    func setLatitude(_ newAddress: String) {
        self.schoolLatitude = newAddress
        updateValue(fieldName: "schoolLatitude", newValue: newAddress)
    }
    
    func setCity(_ newCity: String) {
            self.city = newCity
            updateValue(fieldName: "city", newValue: newCity)
        }
    func setState(_ newState: String) {
            self.state = newState
            updateValue(fieldName: "state", newValue: newState)
        }
    
    func setSchool(_ newSchool: String) {
        self.school = newSchool
        updateValue(fieldName: "school", newValue: newSchool)
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
        let group = db.collection("Group").document(id)
        group.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Group?> {
        let (promise, resolver) = Promise<Group?>.pending()
        
        let db = Firestore.firestore()
        let groups = db.collection("Group").document(id)
        
        groups.getDocument { (document, err) in
            let group = Group()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    group.id = document.documentID
                    group.name = data["name"] as! String
                    group.address = data["address"] as! String
                    group.school = data["school"] as! String
                    group.equipment = data["equipment"] as! [String]
                    group.futureEvents = data["futureEvents"] as! [String]
                    group.higherPrice = data["higherPrice"] as! NSNumber
                    group.lowerPrice = data["lowerPrice"] as! NSNumber
                    group.previousEvents = data["previousEvents"] as! [String]
                    group.profilePic = data["profilePic"] as! String
                    group.schoolLatitude = data["schoolLatitude"] as! String
                    group.schoolLongitude = data["schoolLongitude"] as! String

                }
                resolver.fulfill(group)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
            
            
        }
        return promise
    }
    
    static func createNew(withID groupID: String) -> Group {
        let db = Firestore.firestore()
        let groups = db.collection("Group")

        let newGroup = Group()
        newGroup.id = groupID
        
        groups.document(groupID).setData([
            "name": newGroup.name,
            "address": newGroup.address,
            "school": newGroup.school,
            "state": newGroup.state,
            "city": newGroup.city,
            "equipment": newGroup.equipment,
            "futureEvents": newGroup.futureEvents,
            "higherPrice": newGroup.higherPrice,
            "lowerPrice": newGroup.lowerPrice,
            "previousEvents": newGroup.previousEvents,
            "profilePic": newGroup.profilePic,
            "schoolLatitude" : newGroup.schoolLatitude,
            "schoolLongitude" : newGroup.schoolLongitude


        ])
        
        return newGroup
    }
}
