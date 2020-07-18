 //
 //  createRequestView.swift
 //  Booking
 //
 //  Created by Eimara Mirza on 6/23/20.
 //  Copyright © 2020 Rehan. All rights reserved.
 //
 
 import Foundation
 import UIKit
 import Firebase
 import FirebaseDatabase
 import FSCalendar
 
 class createRequestView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var DJNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var playingFeeLabel: UILabel!
    @IBOutlet weak var eventListTable: UITableView!
    
    var group: Group?
    var dj: DJ?
    var parentView: DJProfileForGroupViewController?
    var DJUID: String?
    var eventIDs: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load in the DJ
        
        eventListTable.delegate = self
        eventListTable.dataSource = self
        eventListTable.register(UINib(nibName: "EventSelectionCell", bundle: nil), forCellReuseIdentifier: "EventSelectionCell")

        
        if let DJuid = self.DJUID {
            _ = DJ.fromID(id: DJuid).done { loadedDJ in
                self.dj = loadedDJ
                self.DJNameLabel.text = loadedDJ?.name
                self.playingFeeLabel.text = "\(String(describing: loadedDJ?.playingFee ?? 0))"
            }
        }
        // load in current user
        if let groupuid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: groupuid).done { loadedGroup in
                if let group = loadedGroup {
                    self.group = group
                    self.refreshData()
                }
            }
        }
    }
    
    func refreshData() {
        let db = Firestore.firestore()

        db.collection("Events").whereField("hostID", isEqualTo: self.group?.id ?? "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.eventIDs.append(document.documentID)
                }
                self.eventListTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let selectedChatCell = tableView.cellForRow(at: indexPath) as? EventSelectionCell {
            if selectedChatCell.checkMarkIsHidden {
                selectedChatCell.setCheckMarkVisibility(visible: true)
            } else {
                selectedChatCell.setCheckMarkVisibility(visible: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventSelectionCell", for: indexPath) as! EventSelectionCell

        cell.setup(eventUID: eventIDs[indexPath.row])

        return cell
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        let identifier = UUID()
        let request = Request.createNew(withID: "\(String(describing: identifier ))")
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter
        }()
        
        request.setDate(dateFormatter.string(from: Date()))
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                if let loadedGroup = loadedGroup {
                    self.group = loadedGroup
                    request.setHostID(loadedGroup.id)
                    request.setHostName(loadedGroup.name)
                    request.setSchool(loadedGroup.school)
                    request.setAddress(loadedGroup.address)
                }
            }
            if let DJuid = self.DJUID {
                _ = DJ.fromID(id: DJuid).done { loadedDJ in
                    if let loadedDJ = loadedDJ {
                        self.dj = loadedDJ
                        request.setDJName(loadedDJ.name)
                        request.setDJID(loadedDJ.id)
                        request.setStatus("open")
                        request.setPaymentStatus(false)
                        if self.playingFeeLabel != nil, let text = self.playingFeeLabel.text {
                            let offer = String(text)
                            request.setCounterFee(offer)
                        }
                        else {
                            let offer = "\(String(describing: loadedDJ.playingFee))"
                            request.setOriginalFee(offer)
                        }
                    }
                }
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
 }
