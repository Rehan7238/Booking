//
//  StatusNotificationItem.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation

struct StatusNotificationItem: Codable {
  let title: String
  let date: Date
  let link: String
  
  @discardableResult
  static func makeNewsItem(_ notification: [String: AnyObject]) -> StatusNotificationItem? {
    guard let news = notification["alert"] as? String,
      let url = notification["link_url"] as? String  else {
        return nil
    }
    
    let newsItem = StatusNotificationItem(title: news, date: Date(), link: url)
    //let newsStore = StatusNotificationStore.shared
    //newsStore.add(item: newsItem)
    
    //NotificationCenter.default.post(
     // name: StatusNotificationTableViewController.RefreshNewsFeedNotification,
      //object: self)
    
    return newsItem
  }
}
