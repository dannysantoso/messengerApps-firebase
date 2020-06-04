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
        
        self.navigationController?.navigationBar.topItem?.title = "Messages"
        
        //mengambil data dalam firebase database menggunakan observe diakhirnya
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {
            snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                //handle duplicated data that comes
                self.messageDetail.removeAll()
                
                //ngeassign data yang didapet ke class dan array
                for data in snapshot{
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key //key ada uidnya difirebase
                        let info = MessageDetail(messageKey: key, messageData: messageDict)
                        
                        self.messageDetail.append(info)
                    }
                }
            }
            self.messageTableView.reloadData()
        })

        
        messageTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }


    @IBAction func signOut(_ sender: Any) {
        do {
            
            //jika user logout
            try Auth.auth().signOut()
            KeychainWrapper.standard.removeObject(forKey: "uid")
                    
            //membuat rootviewcontroller baru
            let onboardingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "welcome")
            let navigationController = UINavigationController()
            navigationController.viewControllers = [onboardingViewController]
            view.window?.rootViewController = navigationController
            view.window?.makeKeyAndVisible()
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
            
        } catch {
            print("already logged out")
            
        }
        
        
    }
    
    @IBAction func addMessage(_ sender: Any) {
        let destination = ContactVC(nibName: "ContactVC", bundle: nil)
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
}


extension MessageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = ChatVC(nibName: "ChatVC", bundle: nil)
            
        destination.recipient = messageDetail[indexPath.row].recipient
        destination.messageId = messageDetail[indexPath.row].messageRef.key
        
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
