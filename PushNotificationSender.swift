//
//  PushNotificationSender.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"],
                                            
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAwIo5KiQ:APA91bGbt1eAv-VkyEaSPFvu-TLJgqHjmmGTZFGDXVwV_IaxNKFuS1v1DiTYnX7dUAWqRTG80otk7KTJJPyYxNUZq2aCOCjYgfTwFCYKAqJGDunsEWy7EXuCBdyGFVI_-qtXd7OhvhKo", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
