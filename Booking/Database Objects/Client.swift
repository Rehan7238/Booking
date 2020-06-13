//
//  Client.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/10/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class Client {
    
    var id: String = ""
    var name: String = "Name"
    var rating: NSNumber = 0.0
    var schoolName: String = "School"
    var address: String = "Address"
    
    func setName(_ newName: String) {
        self.name = newName
       updateValue(fieldName: "name", newValue: newName)
    }
    
    func setRating(_ newRating: NSNumber) {
        self.rating = newRating
       updateValue(fieldName: "rating", newValue: newRating)
    }
    
    func setSchoolName(_ newSchoolName: String) {
        self.schoolName = newSchoolName
       updateValue(fieldName: "schoolName", newValue: newSchoolName)
    }
    
    func setAddress(_ newAddress: String) {
        self.address = newAddress
       updateValue(fieldName: "address", newValue: newAddress)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let client = db.collection("Clients").document(id)
        client.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Client?> {
        let (promise, resolver) = Promise<Client?>.pending()
        
        let db = Firestore.firestore()
        let client = db.collection("Clients").document(id)
        
        client.getDocument { (document, err) in
            let client = Client()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    client.id = document.documentID
                    client.name = data["name"] as! String
                    client.rating = data["rating"] as! NSNumber
                    client.schoolName = data["schoolName"] as! String
                    client.address = data["address"] as! String
                }
                resolver.fulfill(client)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
            
            
        }
        return promise
    }
    
    static func createNew(withID clientID: String) -> Client {
        let db = Firestore.firestore()
        let clients = db.collection("Clients")

        let newClient = Client()
        newClient.id = clientID
        
        clients.document(clientID).setData([
            "name": newClient.name,
            "rating": newClient.rating,
            "schoolName": newClient.schoolName,
            "address": newClient.address
        ])
        
        return newClient
    }
}
