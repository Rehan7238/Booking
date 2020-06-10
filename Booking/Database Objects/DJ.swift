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
    
    func setName(_ newName: String) {
        self.name = newName
                
        let db = Firestore.firestore()
        let client = db.collection("DJs").document(id)
        client.setData( ["name": newName], merge: true)
    }
    
    func setRating(_ newRating: NSNumber) {
        self.rating = newRating
                
        let db = Firestore.firestore()
        let client = db.collection("DJs").document(id)
        client.setData( ["rating": newRating], merge: true)
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
                }
            } else {
                print("Document does not exist")
            }
            
            resolver.fulfill(dj)
        }
        return promise
    }
}
