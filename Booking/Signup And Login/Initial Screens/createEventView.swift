 //
//  createEventView.swift
//  Booking
//
//  Created by Eimara Mirza on 6/23/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
 
 class createEventView: UIView {
    
    static let instance = createEventView()
    var group: Group?

    
    @IBOutlet var alertView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var eventNameText: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("createEventView", owner: self, options: nil)
        commonInit()
 
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init has not been implemented")
    }
    
    private func commonInit() {
        parentView.frame = CGRect(x:0, y:0,width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showCreateEventView() {
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func onClick(_ sender: Any) {
        let identifier = UUID()
        let event = Event.createNew(withID: "\(String(describing: identifier ))")
        event.setEventName("\(String(describing: identifier ))"
        )
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
                event.setHostID(loadedGroup!.id)
                }
            }
        
       // event.setEventName(self.eventNameText.text!)
        parentView.removeFromSuperview()
 }
 
 }
