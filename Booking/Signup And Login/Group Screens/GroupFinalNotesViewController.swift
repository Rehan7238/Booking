//
//  GroupFinalNotesViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class GroupFinalNotesViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedGetStarted(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "SideMain", bundle: nil)
        let vc: InitialScreen = storyboard.instantiateViewController(withIdentifier: "InitialScreen") as! InitialScreen
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
}
