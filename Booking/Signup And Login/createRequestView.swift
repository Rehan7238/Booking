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
 
 class createRequestView: UIViewController {
    
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var DJNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var playingFeeOfferTextField: UITextField!
    
    var group: Group?
    var dj: DJ?
    var parentView: DJProfileForGroupViewController?
    var DJUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load in the DJ
        if let DJuid = self.DJUID {
        _ = DJ.fromID(id: DJuid).done { loadedDJ in
            self.dj = loadedDJ
            self.DJNameLabel.text = self.dj?.name
            self.playingFeeOfferTextField.text = "\(String(describing: self.dj?.playingFee ?? 0))"
            }
        }
        // load in current user
        if let groupuid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: groupuid).done { loadedGroup in
                    self.group = loadedGroup
                }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
            let identifier = UUID()
            let request = Request.createNew(withID: "\(String(describing: identifier ))")
            
            if let uid = Auth.auth().currentUser?.uid {
                _ = Group.fromID(id: uid).done { loadedGroup in
                    self.group = loadedGroup
                    request.setHostID(loadedGroup!.id)
                    request.setHostName(loadedGroup!.name)
                    request.setSchool(loadedGroup!.school)
                    request.setAddress(loadedGroup!.address)
                    
                }
                if let DJuid = self.DJUID {
                _ = DJ.fromID(id: DJuid).done { loadedDJ in
                    self.dj = loadedDJ
                    request.setDJName(loadedDJ!.name)
                    request.setDJID(loadedDJ!.id)
                    request.setStatus("open")
                    request.setPaymentStatus(false)
                    if self.playingFeeOfferTextField != nil {
                    let offer = String(self.playingFeeOfferTextField.text!)
                    request.setCounterFee(offer)
                    }
                    else {
                        let offer = "\(String(describing: loadedDJ?.playingFee ?? 0))"
                        request.setCounterFee(offer)
                    }
                    }
                }
        
                self.dismiss(animated: true, completion: nil)

        }
    }
 }
