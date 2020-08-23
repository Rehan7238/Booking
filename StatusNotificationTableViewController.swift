//
//  StatusNotificationTableViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

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
import FirebaseStorage
import FirebaseFirestore

class StatusNotificationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var group: Group?
    var request: Request?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerIcon: UIImageView!
    
    var results: [String] = [String]()
    var dragPercent: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BackgroundImage
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.refreshData()
            }
        }
        
        let panGesture = UIPanGestureRecognizer(target: self.view, action: #selector(self.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.view.isUserInteractionEnabled = true
        
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {

        print("HELLO")
        
        let percent = max(panGesture.translation(in: view).x, 0) / view.frame.width

        switch panGesture.state {

        case .began:
            navigationController?.delegate = self
            navigationController?.popViewController(animated: true)

        case .changed:
            dragPercent = (percent)
            self.view.transform = CGAffineTransform(translationX: percent * self.view.frame.size.width, y: 0)
            print("A")
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x

            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                self.dismiss(animated: true, completion: nil)
            } else {
                dragPercent = 0
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }

        case .cancelled, .failed:
            dragPercent = 0
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)

        default:
            break
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                self.refreshData()
            }
            
        }
    }
    
    func refreshData() {
        let db = Firestore.firestore()
        db.collection("StatusNotificationItem").whereField("hostID", isEqualTo: group?.id ?? "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.results = [String]()
                for document in querySnapshot!.documents {
                    self.results.append(document.documentID)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusNotificationCell") as! StatusNotificationCell
        let id = results[indexPath.row]
        cell.setup(statusNotificationItemID: id)
        //cell.layer.cornerRadius = cell.frame.height / 3
        //cell.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //cell.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequestid = results[indexPath.row]
        print (selectedRequestid)
        
    }
    
}
