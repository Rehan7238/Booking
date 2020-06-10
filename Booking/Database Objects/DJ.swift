//
//  DJ.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class DJ {
    
    var id: String = ""
    var name: String = "Name"
    var rating: NSNumber = 0.0
    var city: String = "City"
    var state: String = "State"
    
    func setName(_ newName: String) {
        self.name = newName
        updateValue(fieldName: "name", newValue: newName)
    }
    
    func setRating(_ newRating: NSNumber) {
        self.rating = newRating
        updateValue(fieldName: "rating", newValue: newRating)
    }
    
    func setCity(_ newCity: String) {
        self.city = newCity
        updateValue(fieldName: "city", newValue: newCity)
    }
    
    func setState(_ newState: String) {
        self.state = newState
        updateValue(fieldName: "state", newValue: newState)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let client = db.collection("DJs").document(id)
        client.setData( [fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<DJ> {
        let (promise, resolver) = Promise<DJ>.pending()
        
        let db = Firestore.firestore()
        let djs = db.collection("DJs").document(id)
        
        djs.getDocument { (document, err) in
            let dj = DJ()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    dj.id = document.documentID
                    dj.name = data["name"] as! String
                    dj.rating = data["rating"] as! NSNumber
                    dj.city = data["city"] as! String
                    dj.state = data["state"] as! String
                }
            } else {
                print("Document does not exist")
            }
            
            resolver.fulfill(dj)
        }
        return promise
    }
}
