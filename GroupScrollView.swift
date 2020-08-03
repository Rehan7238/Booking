//
//  GroupScrollView.swift
//  Booking
//
//  Created by Humayun Chaudhry on 8/3/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import Pageboy

class GroupScrollView: PageboyViewController, PageboyViewControllerDataSource {
    
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "SideMain", bundle: nil)
        let profileVC: GroupProfileViewController = storyboard.instantiateViewController(withIdentifier: "GroupProfileViewController") as! GroupProfileViewController
        let calendarVC: GroupCalendarViewController = storyboard.instantiateViewController(withIdentifier: "GroupCalendarViewController") as! GroupCalendarViewController
        let exploreVC: GroupExploreViewController = storyboard.instantiateViewController(withIdentifier: "GroupExploreViewController") as! GroupExploreViewController
        let notificationsVC: StatusNotificationTableViewController = storyboard.instantiateViewController(withIdentifier: "StatusNotificationTableViewController") as! StatusNotificationTableViewController

        viewControllers.append(profileVC)
        viewControllers.append(calendarVC)
        viewControllers.append(exploreVC)
        viewControllers.append(notificationsVC)

        self.dataSource = self
        self.reloadData()
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        self.scrollToPage(.at(index: 0), animated: true)
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        self.scrollToPage(.at(index: 1), animated: true)
    }
    
    @IBAction func exploreButtonPressed(_ sender: Any) {
        self.scrollToPage(.at(index: 2), animated: true)
    }
    
    @IBAction func notificationButtonPressed(_ sender: Any) {
        self.scrollToPage(.at(index: 3), animated: true)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: Int, direction: NavigationDirection, animated: Bool) {
        print("scrolling to page \(index)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
    didScrollToPageAt index: Int,
    direction: NavigationDirection,
    animated: Bool) {
        print("scrolled to page \(index)")

    }
    
}
