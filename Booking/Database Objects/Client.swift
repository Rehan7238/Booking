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
    
    func setName(_ newName: String) {
        self.name = newName
                
        let db = Firestore.firestore()
        let client = db.collection("Clients").document(id)
        client.setData(["name": newName], merge: true)
    }
    
    func setRating(_ newRating: NSNumber) {
        self.rating = newRating
                
        let db = Firestore.firestore()
        let client = db.collection("Clients").document(id)
        client.setData(["rating": newRating], merge: true)
    }
    
    static func fromID(id: String) -> Promise<Client> {
        let (promise, resolver) = Promise<Client>.pending()
        
        let db = Firestore.firestore()
        let client = db.collection("Clients").document(id)
        
        client.getDocument { (document, err) in
            let client = Client()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    client.id = document.documentID
                    client.name = data["name"] as! String
                    client.rating = data["rating"] as! NSNumber
                }
            } else {
                print("Document does not exist")
            }
            
            resolver.fulfill(client)
        }
        return promise
    }
}
