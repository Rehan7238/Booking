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
    var instagramLink: String = ""
    var equipment: [String] = []
    var hostRating: [NSNumber] = []
    var litness: NSNumber = 0.0
    var locality: String = " "
    var location: String = ""
    var monthsOfExperience: NSNumber = 0.0
    var musicStyle: [String] = []
    var numberOfGigs: NSNumber = 0.0
    var playingFee: NSNumber = 0.0
    var playlist: String = ""
    var previousEvents: [String] = []
    var profilePic: String = ""
    var upcomingEvents: [String] = []
    var univerisity: String = ""
    var notifications: [String] = []
    var tokenForNotifications: String = ""
    
    
    func setName(_ newName: String) {
        self.name = newName
        updateValue(fieldName: "name", newValue: newName)
    }
    
    func setTokenForNotifications(_ newName: String) {
        self.tokenForNotifications = newName
        updateValue(fieldName: "tokenForNotifications", newValue: newName)
    }
    
    func setEquipment(_ newEquipment: [String]) {
        self.equipment = newEquipment
        updateValue(fieldName: "equipment", newValue: newEquipment)
    }
    
    func setNotifications(_ newEquipment: [String]) {
        self.notifications = newEquipment
        updateValue(fieldName: "notifications", newValue: newEquipment)
    }
    
    func setInstagramLink(_ newName: String) {
        self.instagramLink = newName
        updateValue(fieldName: "instagramLink", newValue: newName)
    }
    
    func setHostRating(_ newHostRating: [NSNumber]) {
        self.hostRating = newHostRating
        updateValue(fieldName: "hostRating", newValue: newHostRating)
    }
    
    func setLitness(_ newLitness: NSNumber) {
        self.litness = newLitness
        updateValue(fieldName: "litness", newValue: newLitness)
    }
    
    func setLocality(_ newLocality: String) {
        self.locality = newLocality
        updateValue(fieldName: "locality", newValue: newLocality)
    }
    
    func setLocation(_ newName: String) {
        self.name = newName
        updateValue(fieldName: "location", newValue: newName)
    }
    
    func setUniversity(_ inputUni: String) {
        self.univerisity = inputUni
        updateValue(fieldName: "university", newValue: inputUni)
    }
    
    func setMonthsOfExperience(_ newMonthsOfExperience: NSNumber) {
        self.monthsOfExperience = newMonthsOfExperience
        updateValue(fieldName: "monthsOfExperience", newValue: newMonthsOfExperience)
    }
    
    func setMusicStyle(_ newMusicStyle: [String]) {
        self.musicStyle = newMusicStyle
        updateValue(fieldName: "musicStyle", newValue: newMusicStyle)
    }
    
    func setNumberOfGigs(_ newNumberOfGigs: NSNumber) {
        self.numberOfGigs = newNumberOfGigs
        updateValue(fieldName: "numberOfGigs", newValue: newNumberOfGigs)
    }
    
    func setPlayingFee(_ newPlayingFee: NSNumber) {
        self.playingFee = newPlayingFee
        updateValue(fieldName: "playingFee", newValue: newPlayingFee)
    }
    
    func setPlaylist(_ newPlaylist: String) {
        self.playlist = newPlaylist
        updateValue(fieldName: "playlist", newValue: newPlaylist)
    }
    
    func setPreviousEvents(_ newPreviousEvents: [String]) {
        self.previousEvents = newPreviousEvents
        updateValue(fieldName: "previousEvents", newValue: newPreviousEvents)
    }
    
    func setProfilepic(_ newProfilePic: String) {
        self.profilePic = newProfilePic
        updateValue(fieldName: "profilePic", newValue: newProfilePic)
    }
    
    func setUpcomingEvents(_ newUpcomingEvents: [String]) {
        self.upcomingEvents = newUpcomingEvents
        updateValue(fieldName: "upcomingEvents", newValue: newUpcomingEvents)
    }
    
    private func updateValue(fieldName: String, newValue: Any) {
        let db = Firestore.firestore()
        let dj = db.collection("DJs").document(id)
        dj.setData( [fieldName: newValue], merge: true)
    }
    
    static func fromID(id: String) -> Promise<DJ?> {
        let (promise, resolver) = Promise<DJ?>.pending()
        
        let db = Firestore.firestore()
        let djs = db.collection("DJs").document(id)
        
        djs.getDocument { (document, err) in
            let dj = DJ()
            
            if let document = document, document.exists {
                if let data = document.data() {
                    dj.id = document.documentID
                    dj.name = data["name"] as! String
                    dj.instagramLink = data["instagramLink"] as! String
                    dj.equipment = data["equipment"] as! [String]
                    dj.hostRating = data["hostRating"] as! [NSNumber]
                    dj.litness = data["litness"] as! NSNumber
                    dj.locality = data["locality"] as! String
                    dj.location = data["location"] as! String
                    dj.monthsOfExperience = data["monthsOfExperience"] as! NSNumber
                    dj.musicStyle = data["musicStyle"] as! [String]
                    dj.numberOfGigs = data["numberOfGigs"] as! NSNumber
                    dj.playingFee = data["playingFee"] as! NSNumber
                    dj.playlist = data["playlist"] as! String
                    dj.tokenForNotifications = data["tokenForNotifications"] as! String
                    dj.previousEvents = data["previousEvents"] as! [String]
                    dj.profilePic = data["profilePic"] as! String
                    dj.upcomingEvents = data["upcomingEvents"] as! [String]
                    dj.notifications = data["notifications"] as! [String]

                }
                
                resolver.fulfill(dj)
            } else {
                print("Document does not exist")
                resolver.fulfill(nil)
            }
        }
        return promise
    }
    
    static func createNew(withID DJID: String) -> DJ {
        let db = Firestore.firestore()
        let djs = db.collection("DJs")

        let newDJ = DJ()
        newDJ.id = DJID
        
        djs.document(DJID).setData([
            "name": newDJ.name,
            "equipment": newDJ.equipment,
            "hostRating": newDJ.hostRating,
            "litness": newDJ.litness,
            "locality": newDJ.locality,
            "location": newDJ.location,
            "monthsOfExperience": newDJ.monthsOfExperience,
            "musicStyle": newDJ.musicStyle,
            "numberOfGigs": newDJ.numberOfGigs,
            "playingFee": newDJ.playingFee,
            "playlist": newDJ.playlist,
            "previousEvents": newDJ.previousEvents,
            "profilePic": newDJ.profilePic,
            "upcomingEvents": newDJ.upcomingEvents,
            "instagramLink": newDJ.instagramLink,
            "tokenForNotifications": newDJ.tokenForNotifications,
            "notifications": newDJ.notifications

        ])
        
        return newDJ
    }
}
