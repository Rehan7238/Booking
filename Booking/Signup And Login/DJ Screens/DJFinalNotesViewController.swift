//
//  DJFinalNotesViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 6/22/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class DJFinalNotesViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var infoVersion: UILabel!
    @IBOutlet weak var greekLifeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoVersion.isHidden = !infoVersion.isHidden
    }
    
    @IBAction func pressedNext (_ sender: Any) {
          infoVersion.isHidden = !infoVersion.isHidden;
    }
    
    @IBAction func pressedGetStarted(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "SideMain", bundle: nil)
        let vc: InitialScreen = storyboard.instantiateViewController(withIdentifier: "InitialScreen") as! InitialScreen
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}
