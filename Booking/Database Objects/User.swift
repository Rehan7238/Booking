//
//  User.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/16/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class User {
    
    var id: String = ""
    var name: String = "Name"
    var DJsFollowing: [String] = []
    var favoriteVenues: [String] = []
    var friends: [String] = []
    var futureEvents: [String] = []
    var groups: [String: [String]] = [:]
    
    func setName(_ newValue: String) {
        self.name = newValue
        updateValue(fieldName: "name", newValue: newValue)
    }
    
    func setDJsFollowing(_ newValue: [String]) {
        self.DJsFollowing = newValue
        updateValue(fieldName: "DJsFollowing", newValue: newValue)
    }
    
    func setFavoriteVenues(_ newValue: [String]) {
        self.favoriteVenues = newValue
        updateValue(fieldName: "favoriteVenues", newValue: newValue)
    }
    
    func setFriends(_ newValue: [String]) {
        self.friends = newValue
        updateValue(fieldName: "friends", newValue: newValue)
    }
    
    func setFutureEvents(_ newValue: [String]) {
        self.futureEvents = newValue
        updateValue(fieldName: "futureEvents", newValue: newValue)
    }
    
    func setGroups(_ newValue: [String: [String]]) {
        self.groups = newValue
        updateValue(fieldName: "groups", newValue: newValue)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let user = db.collection("Users").document(id)
        user.setData([fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<User?> {
        let (promise, resolver) = Promise<User?>.pending()
        
        let db = Firestore.firestore()
        let users = db.collection("Users").document(id)
        
        users.getDocument { (document, err) in
            let user = User()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    user.id = document.documentID
                    user.name = data["name"] as! String
                    user.DJsFollowing = data["DJsFollowing"] as! [String]
                    user.favoriteVenues = data["favoriteVenues"] as! [String]
                    user.friends = data["friends"] as! [String]
                    user.futureEvents = data["futureEvents"] as! [String]
                    user.groups = data["groups"] as! [String: [String]]

                }
                resolver.fulfill(user)
            } else {
                resolver.fulfill(nil)
                print("Document does not exist")
            }
            
            
        }
        return promise
    }
    
    static func createNew(withID userID: String) -> User {
        let db = Firestore.firestore()
        let users = db.collection("Users")

        let newUser = User()
        newUser.id = userID
        
        users.document(userID).setData([
            "name": newUser.name,
            "DJsFollowing": newUser.DJsFollowing,
            "favoriteVenues": newUser.favoriteVenues,
            "friends": newUser.friends,
            "futureEvents": newUser.futureEvents,
            "groups": newUser.groups
        ])
        
        return newUser
    }
}
