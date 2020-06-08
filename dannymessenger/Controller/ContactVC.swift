//
//  ContactVC.swift
//  dannymessenger
//
//  Created by danny santoso on 04/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ContactVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactTableView: UITableView!
    
    var contacts = [Contact]()
    var filteredData = [Contact]()
    var isSearching = false
    var contact: Contact!
    var recipient: String!
    var messageId: String!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        self.navigationController?.navigationBar.topItem?.title = "Contacts"
        
        loadData()
        
        
        
        
        // Do any additional setup after loading the view.
        contactTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactCell")
    }
    
    func loadData(){
        
        Database.database().reference().child("users").observe(.value, with: {
            snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.contacts.removeAll()
                    
                    for data in snapshot {
                        
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                            
                            let key = data.key
                            print(key)
                            
                            if let username = postDict["username"] as? String {
                                
                                print(username)
                            }
                            
                            
                            Database.database().reference().child("users").child(key).child("messages").observe(.value, with: {
                                snapshot2 in
                                    if let snapshot2 = snapshot2.children.allObjects as? [DataSnapshot] {
                                        for (index,data2) in snapshot2.enumerated(){
                                            if let postDict2 = data2.value as? Dictionary<String, AnyObject> {
                                                if let recipient = postDict2["recipient"] as? String {
                                                    if recipient == self.currentUser! {
                                                        self.contacts[index]._messageId = data2.key
                                                    }
                                                        
                                                }
                                            }
                                        }
                                    }
                                        
                                })
                            
                            let post = Contact(userKey: key, postData: postDict, messageId: "")

                            self.contacts.append(post)
                            
                            
                        }
                    }
                }
                
                self.contactTableView.reloadData()
        })
        
        
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            
            view.endEditing(true)
            
            contactTableView.reloadData()
            
        } else {
            
            isSearching = true
            
            filteredData = contacts.filter({ $0.username == searchBar.text! })
            
            contactTableView.reloadData()
        }
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("tes")
    }
    
}

extension ContactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            recipient = filteredData[indexPath.row].userKey
            messageId = filteredData[indexPath.row].messageId
        }else{
            recipient = contacts[indexPath.row].userKey
            messageId = contacts[indexPath.row].messageId
        }
        
        let destination = ChatVC(nibName: "ChatVC", bundle: nil)
            
        destination.recipient = recipient
        destination.messageId = messageId
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ContactVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }else{
            return contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchData: Contact!
        
        if isSearching{
            searchData = filteredData[indexPath.row]
        }else{
            searchData = contacts[indexPath.row]
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell {
            
            cell.configureCell(contact: searchData)
            
            return cell
        }else{
        
            return ContactTableViewCell()
        }
        
        
    }
    
     
}

