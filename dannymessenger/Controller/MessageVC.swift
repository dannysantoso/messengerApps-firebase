//
//  MessageVC.swift
//  dannymessenger
//
//  Created by danny santoso on 02/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageVC: UIViewController {

    
    @IBOutlet weak var messageTableView: UITableView!
    
    var messageDetail = [MessageDetail]()
    var detail: MessageDetail!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var recipient: String!
    var messageId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {
            snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                //handle duplicated data that comes
                self.messageDetail.removeAll()
                
                for data in snapshot{
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
            self.messageTableView.reloadData()
        })

        // Do any additional setup after loading the view.
        messageTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }


    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
        dismiss(animated: true, completion: nil)
    }
    

}


extension MessageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = ChatVC(nibName: "ChatVC", bundle: nil)
            
        destination.recipient = messageDetail[indexPath.row].recipient
        destination.messageId = messageDetail[indexPath.row].messageRef.key
        
        self.present(destination, animated: true)
        
    }
    
}

extension MessageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDetails = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell {
            
            cell.configureCell(messageDetail: messageDetails)
            
            return cell
        }else{
        
            return MessageTableViewCell()
        }
        
        
    }
    
     
}
