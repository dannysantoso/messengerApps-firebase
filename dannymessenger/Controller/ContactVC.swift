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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
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
                            
                            let post = Contact(userKey: key, postData: postDict)
                            
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
        }else{
            recipient = contacts[indexPath.row].userKey
        }
        
        let destination = ChatVC(nibName: "ChatVC", bundle: nil)
            
        destination.recipient = recipient
        destination.messageId = messageId
        
        self.present(destination, animated: true)
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

