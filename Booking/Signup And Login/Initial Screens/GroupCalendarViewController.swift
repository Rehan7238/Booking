//
//  GroupCalendarViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/26/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase


class GroupCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createEventButton: UIButton!
    var group: Group?
    var results: [String] = [String]()
    var allResults: [String] = [String]()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2

        tableView.delegate = self
        tableView.dataSource = self
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.allowsMultipleSelection = false
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                //self.groupName.text = self.group?.name
                
                self.refreshData(Date())
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshData(_ date: Date) {
        let db = Firestore.firestore()

        db.collection("Events").whereField("school", isEqualTo: group?.school ?? "").getDocuments() { (querySnapshot, err) in
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
        return cell
    }
    
    @IBAction func toggleClicked(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    @IBAction func createEventClicked(_ sender: Any) {
        if let createEventVC = Bundle.main.loadNibNamed("createEventView", owner: nil, options: nil)?.first as? createEventView {
            createEventVC.parentView = self
            self.present(createEventVC, animated: true, completion: nil)
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
