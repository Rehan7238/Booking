//
//  DJScrollView.swift
//  Booking
//
//  Created by Humayun Chaudhry on 8/3/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import Pageboy

class DJScrollView: PageboyViewController, PageboyViewControllerDataSource {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    
    var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "SideMain", bundle: nil)
        let profileVC: DJProfileViewController = storyboard.instantiateViewController(withIdentifier: "DJProfileViewController") as! DJProfileViewController
        let calendarVC: DJHomePageViewController = storyboard.instantiateViewController(withIdentifier: "DJHomePageViewController") as! DJHomePageViewController
        let exploreVC: DJExplorePageViewController = storyboard.instantiateViewController(withIdentifier: "DJExplorePageViewController") as! DJExplorePageViewController
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
    
    @IBAction func createEventButtonPressed(_ sender: Any) {
        if let createEventVC = Bundle.main.loadNibNamed("createEventView", owner: nil, options: nil)?.first as? createEventView {
           self.present(createEventVC, animated: true, completion: nil)
        }
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
