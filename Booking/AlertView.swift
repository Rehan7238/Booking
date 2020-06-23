 //
//  AlertView.swift
//  Booking
//
//  Created by Eimara Mirza on 6/23/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
 
 class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
 
    }
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    private func commonInit() {
        parentView.frame = CGRect(x:0, y:0,width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func showAlert(message: String) {
        self.message.text = message
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    @IBAction func onClick(_ sender: Any) {
        parentView.removeFromSuperview()
    }
    
 }
