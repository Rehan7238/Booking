//
//  GroupExploreViewController.swift
//  Booking
//
//  Created by Eimara Mirza on 7/6/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import EHHorizontalSelectionView
import CoreLocation

class GroupExploreViewController: UIViewController, EHHorizontalSelectionViewProtocol {
    
    //Mark: Properties
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var trendingDJsView: EHHorizontalSelectionView!
    @IBOutlet weak var inyourCityView: EHHorizontalSelectionView!
    @IBOutlet weak var budgetDJView: EHHorizontalSelectionView!
    @IBOutlet weak var headerIcon: UIImageView!
    
    var group: Group?
    var allResults: [DJ]?
    var filteredResults: [DJ]?
    var trendingResults: [DJ]?
    var inyourCityResults: [DJ]?
    var budgetResults: [DJ]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BackgroundImage
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        trendingDJsView.delegate = self
        inyourCityView.delegate = self
        budgetDJView.delegate = self

        trendingDJsView.registerCellNib(UINib(nibName: "ExplorePageSearchResultCell", bundle: nil), with: ExplorePageSearchResultCell.self, reuseIdentifier: "ExplorePageSearchResultCell")
        inyourCityView.registerCellNib(UINib(nibName: "ExplorePageSearchResultCell", bundle: nil), with: ExplorePageSearchResultCell.self, reuseIdentifier: "ExplorePageSearchResultCell")
        budgetDJView.registerCellNib(UINib(nibName: "ExplorePageSearchResultCell", bundle: nil), with: ExplorePageSearchResultCell.self, reuseIdentifier: "ExplorePageSearchResultCell")
        
        if let uid = Auth.auth().currentUser?.uid {
            _ = Group.fromID(id: uid).done { loadedGroup in
                self.group = loadedGroup
            }
        }
        
        let db = Firestore.firestore()
        db.collection("DJs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dispatch = DispatchGroup()
                for document in querySnapshot!.documents {
                    dispatch.enter()
                    _ = DJ.fromID(id: document.documentID).done { loadedDJ in
                        if let dj = loadedDJ {
                            if self.allResults == nil {
                                self.allResults = [dj]
                            } else {
                                self.allResults?.append(dj)
                            }
                        }
                        dispatch.leave()
                    }
                }
                dispatch.notify(queue: .main) {
                    if let allResults = self.allResults {
                        for result in allResults {
                            if self.filteredResults == nil {
                                self.filteredResults = [result]
                            } else {
                                self.filteredResults?.append(result)
                            }
                        }
                    }
                    if let filteredResults = self.filteredResults {
                        let dispatch2 = DispatchGroup()

                        for result in filteredResults {
                            if Double(truncating: result.playingFee) >= Double(truncating: self.group?.lowerPrice ?? 0.00) && Double(truncating: result.playingFee) <= Double(truncating: self.group?.higherPrice ?? 0.00) {
                                if self.budgetResults == nil {
                                    self.budgetResults = [result]
                                } else {
                                    self.budgetResults?.append(result)
                                }
                            } else {
                                dispatch2.enter()
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(result.location) {
                                    placemarks, error in
                                    if error != nil {
                                        dispatch2.leave()
                                    } else {
                                        let placemark = placemarks?.first
                                        if let djcord = placemark?.location?.coordinate {
                                            geocoder.geocodeAddressString(self.group?.address ?? "") {
                                                placemarks, error in
                                                if error != nil {
                                                    dispatch.leave()
                                                } else {
                                                    let placemark = placemarks?.first
                                                    if let groupcord = placemark?.location?.coordinate {
                                                        if djcord.distance(to: groupcord) * 0.00062137 < 15 {
                                                            if self.inyourCityResults == nil {
                                                                self.inyourCityResults = [result]
                                                            } else {
                                                                self.inyourCityResults?.append(result)
                                                            }
                                                            self.inyourCityView.reloadData()
                                                        }
                                                    }
                                                    dispatch2.leave()
                                                }
                                            }
                                        } else {
                                            dispatch2.leave()
                                        }
                                    }
                                }
                            }
                        }
                        
                        dispatch2.notify(queue: .main) {
                            if let filteredResults = self.filteredResults {
                                for result in filteredResults {
                                    var alreadyUsed = false
                                    if let budgetResults = self.budgetResults {
                                        for budgetResult in budgetResults {
                                            if budgetResult == result {
                                                alreadyUsed = true
                                            }
                                        }
                                    }
                                    if let inyourCityResults = self.inyourCityResults {
                                        for inyourCityResult in inyourCityResults {
                                            if inyourCityResult == result {
                                                alreadyUsed = true
                                            }
                                        }
                                    }
                                    if !alreadyUsed {
                                        if self.trendingResults == nil {
                                            self.trendingResults = [result]
                                        } else {
                                            self.trendingResults?.append(result)
                                        }
                                    }
                                }
                            }
                            
                            self.trendingDJsView.reloadData()
                            self.inyourCityView.reloadData()
                            self.budgetDJView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func numberOfItems(inHorizontalSelection hSelView: EHHorizontalSelectionView) -> UInt {
        switch hSelView {
        case trendingDJsView:
            return UInt(trendingResults?.count ?? 0)
        case inyourCityView:
            return UInt(inyourCityResults?.count ?? 0)
        case budgetDJView:
            return UInt(budgetResults?.count ?? 0)
        default:
            return UInt(filteredResults?.count ?? 0)
        }
    }
    
    func selectionView(_ selectionView: EHHorizontalSelectionView, cellForItemAt indexPath: IndexPath) -> EHHorizontalViewCell? {
        let cell = selectionView.dequeueReusableCell(withReuseIdentifier: "ExplorePageSearchResultCell", for: indexPath) as! ExplorePageSearchResultCell
        
        switch selectionView {
        case trendingDJsView:
            if let djID = trendingResults?[indexPath.row] {
                cell.setup(dj: djID)
            }
        case inyourCityView:
            if let djID = inyourCityResults?[indexPath.row] {
                cell.setup(dj: djID)
            }
        case budgetDJView:
            if let djID = budgetResults?[indexPath.row] {
                cell.setup(dj: djID)
            }
        default:
            if let djID = filteredResults?[indexPath.row] {
                cell.setup(dj: djID)
            }
        }
        
        return cell
    }
    
    func titleForItem(at index: UInt, forHorisontalSelection hSelView: EHHorizontalSelectionView) -> String? {
        return ""
    }
    
    @IBAction func searchBarResultTyped(_ sender: Any) {

    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(round(Double(filteredResults?.count ?? 0) / 2.0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! ExplorePageSearchResultCell
        cell.setup(dj: id)
        return cell
    }*/
}
