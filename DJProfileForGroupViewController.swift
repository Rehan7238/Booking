//
//  DJProfileForGroupViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/11/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FSCalendar
import SkyFloatingLabelTextField;
import GooglePlaces
import PromiseKit
import Firebase
import MBCircularProgressBar


class DJProfileForGroupViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var playingFeeLabel: UILabel!
    @IBOutlet weak var numberOfGigsNumber: UILabel!
    @IBOutlet weak var playlistLinkButton: UIButton!
    @IBOutlet weak var matchProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var ratingProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var dependabilityBar: MBCircularProgressBarView!
    @IBOutlet weak var profileCard: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dj: DJ?
    var group: Group?
    var event: Event?
    var DJUID: String?
    var DJrating = 0
    var results: [String] = [String]()
    var allResults: [String] = [String]()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchProgressBar.value = 0
        self.ratingProgressBar.value = 0
        self.dependabilityBar.value = 0
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        
        //BackgroundImage
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        requestButton.layer.cornerRadius = requestButton.frame.height / 5
        profileCard.layer.cornerRadius = profileCard.frame.height / 9
        
        if let uid = self.DJUID {
            _ = DJ.fromID(id: uid).done { [self] loadedDJ in
                self.dj = loadedDJ
                self.djName.text = self.dj?.name
                self.locationLabel.text = self.dj?.location
                self.numberOfGigsNumber.text = "0"
                if let playlistLink = self.dj?.playlist, !playlistLink.isEmpty {
                    self.playlistLinkButton.setTitle(playlistLink, for: .normal)
                } else {
                    self.playlistLinkButton.setTitle("", for: .normal)
                }
                if let profilePic = self.dj?.profilePic, !profilePic.isEmpty {
                    self.profilePic.downloadImage(from: URL(string: profilePic)!)
                    var calculatedRating = 0
                    if let ratings = self.dj?.hostRating {
                        for rating in ratings {
                            calculatedRating = calculatedRating + Int(truncating: rating)
                            self.DJrating = calculatedRating
                        }
                    }
                    self.numberOfGigsNumber.text = "\(String(describing: self.dj?.numberOfGigs ?? 0))"
                    self.playingFeeLabel.text = "$" + "\(String(describing: self.dj?.playingFee ?? 0))"
                }
            }
        }
    }
    
    @IBAction func playlistLinkClicked(_ sender: Any) {
        if let playlistLink = self.dj?.playlist, !playlistLink.isEmpty {
            guard let url = URL(string: playlistLink) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 10.0) {
            self.matchProgressBar.value = 20
            self.ratingProgressBar.value = CGFloat(self.DJrating)
        }
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        var favDJs = group?.favoriteDJs
        favDJs?.append("\(String(describing: DJUID))")
        group?.setFavoriteDJs(favDJs ?? [""])
           }


    @IBAction func createRequestClicked(_ sender: Any) {

        if let createRequestVC = Bundle.main.loadNibNamed("createRequestView", owner: nil, options: nil)?.first as? createRequestView {
            if let DJUID = self.DJUID {
                createRequestVC.setup(djID: DJUID)
                self.present(createRequestVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func InstagramAction() {
        if let dj = dj{
            let username =  dj.instagramLink// Your Instagram Username here}
            
            let appURL = URL(string: "instagram://user?username=" + (username))!
            
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: "https://instagram.com/\(username)")!
                application.open(webURL)
            }
        }
    }
    
    func refreshData(_ date: Date) {
        let db = Firestore.firestore()

        db.collection("Events").whereField("DJID", isEqualTo: dj?.id ?? "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.results = [String]()
                self.allResults = [String]()
                
                for document in querySnapshot!.documents {
                    self.allResults.append(document["date"] as? String ?? "")
                    if document["date"] as? String == self.dateFormatter.string(from: date) {
                        self.results.append(document.documentID)
                    }
                }
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter.string(from: date)

        var eventCount = 0
        
        for eventDateString in self.allResults {
            if eventDateString == dateString {
                eventCount += 1
            }
        }
        return eventCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        let id = results[indexPath.row]
        cell.setup(eventID: id)
        cell.layer.cornerRadius = cell.frame.height / 3
//        _ = Event.fromID(id: id).done { loadedEvent in
//        self.event = loadedEvent
//            if self.event?.hostID == self.group?.id {
//            }
//            else if self.event?.hostID != self.group?.id {
//            }
//        }
        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        refreshData(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

