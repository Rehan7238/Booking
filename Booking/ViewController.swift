//
//  ViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/7/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Client.fromID(id: "fBJVqzKsT5Zv0mxC9IMv").done { client in
            print(client.name)
            print(client.rating)
            client.setName("Alphebet Theta Pie")
            print(client.name)
        }
        
        _ = DJ.fromID(id: "aNCu8ijFlYKbtJhK6MR4").done { dj in
            print(dj.name)
            print(dj.rating)
        }
    }
}

