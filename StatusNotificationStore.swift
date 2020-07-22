//
//  StatusNotificationStore.swift
//  Booking
//
//  Created by Eimara Mirza on 7/21/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit

class StatusNotificationStore {
  static let shared = StatusNotificationStore()
  
  var items: [StatusNotificationItem] = []
  
  init() {
    loadItemsFromCache()
  }
  
  func add(item: StatusNotificationItem) {
    items.insert(item, at: 0)
    saveItemsToCache()
  }
}


// MARK: Persistance
extension StatusNotificationStore {
  func saveItemsToCache() {
    do {
      let data = try JSONEncoder().encode(items)
      try data.write(to: itemsCache)
    } catch {
      print("Error saving news items: \(error)")
    }
  }
  
  func loadItemsFromCache() {
    do {
      guard FileManager.default.fileExists(atPath: itemsCache.path) else {
        print("No news file exists yet.")
        return
      }
      let data = try Data(contentsOf: itemsCache)
      items = try JSONDecoder().decode([StatusNotificationItem].self, from: data)
    } catch {
      print("Error loading news items: \(error)")
    }
  }
  
  var itemsCache: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
    return documentsURL.appendingPathComponent("news.dat")
  }
}
