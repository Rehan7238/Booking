//
//  InviteContactsViewController.swift
//  Booking
//
//  Created by Rehan Chaudhry on 6/24/20.
//  Copyright © 2020 Rehan. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import MessageUI

class InviteContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    struct FetchedContact {
        var firstName: String
        var lastName: String
        var telephone: String
    }
    
    var contacts: [FetchedContact] = []
    let store = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
        store.requestAccess(for: .contacts) { (access, error) in
            if access {
                self.fillContactsTable()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    func displayMessageInterface(recipient: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.recipients = [recipient]
        composeVC.body = "Join XOXO and easily discover your local DJ's and Events! (Appstore Link Here)"
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    func fillContactsTable() {
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
            })
        } catch let error {
            print("Failed to enumerate contact", error)
        }
        contactsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactInfo = contacts[indexPath.row]
        let tableCell =  tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! InviteContactsCell
        tableCell.setup(self, friendName: contactInfo.firstName + " " + contactInfo.lastName, phoneNumber: contactInfo.telephone, userType: "- DJ", isActiveUser: true)
        return tableCell
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
