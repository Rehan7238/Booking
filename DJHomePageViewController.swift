//
//  DJHomePageViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/30/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseFirestore


class DJHomePageViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var dj: DJ?
    var event: Event?
    var results: [String] = [String]()
    var allResults: [String] = [String]()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.allowsMultipleSelection = false
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = DJ.fromID(id: uid).done { loadedDJ in
                self.dj = loadedDJ
                self.refreshData(Date())
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        _ = Event.fromID(id: id).done { loadedEvent in
        self.event = loadedEvent
            if self.event?.DJID == self.dj?.id {
                cell.layer.borderColor = #colorLiteral(red: 1, green: 0.1633785235, blue: 0.9432822805, alpha: 1)
                cell.layer.borderWidth = 1.0
            }
            else if self.event?.DJID != self.dj?.id {
                cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.layer.borderWidth = 1.0
            }
        }
        return cell
    }
    
    @IBAction func toggleClicked(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
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
