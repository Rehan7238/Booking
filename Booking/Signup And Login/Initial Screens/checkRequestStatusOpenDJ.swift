 //
 //  checkRequestStatusOpenDJ.swift
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
 
 class checkRequestStatusOpenDJ: UIViewController {
    
    @IBOutlet var doneButton: UIButton! = UIButton()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DJNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var counterFeeTextField: UITextField!
    @IBOutlet weak var counterButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var request: Request?
    var DJparentView: DJProfileViewController?

    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setup(uid: String) {
        self.uid = uid
        if let uid = self.uid {
            _ = Request.fromID(id: uid).done { loadedRequest in
                self.request = loadedRequest
                self.eventNameLabel.text = loadedRequest?.eventName
                self.DJNameLabel.text = loadedRequest?.DJName
                self.dateLabel.text = loadedRequest?.date
                //self.eventNameLabel.text = loadedRequest?.eventName
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedAccept(_ sender: Any) {
        request?.setStatus("accepted")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func clickedDecline(_ sender: Any) {
        request?.setStatus("declined")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedCounter(_ sender: Any) {
        request?.setStatus("countered")
        request?.setCounterFee(counterFeeTextField.text!)
        request?.setCounteringParty("DJ")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 }
