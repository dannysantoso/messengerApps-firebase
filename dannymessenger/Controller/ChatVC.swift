//
//  ChatVC.swift
//  dannymessenger
//
//  Created by danny santoso on 03/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatVC: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var recipient: String!
    var messageId: String!
    var chats = [Chat]()
    var chat: Chat!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")

    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.delegate = self
        chatTableView.dataSource = self
//        chatTableView.rowHeight = UITableView.automaticDimension
//        chatTableView.estimatedRowHeight = 300
        
        if messageId != "" && messageId != nil {
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
            self.moveToBottom()
        }
    }
    
    @objc func keyboardWillShow(notify: NSNotification){
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notify: NSNotification){
        if let keyboardSize = (notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func moveToBottom(){
        if chats.count > 0 {
            let indexPath = IndexPath(row: chats.count-1, section: 0)
            
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func loadData(){
        Database.database().reference().child("messages").child(messageId).observe(.value, with: {
            snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.chats.removeAll()
                    
                    for data in snapshot {
                        
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                            
                            let key = data.key
                            
                            let post = Chat(messageKey: key, postData: postDict)
                            
                            self.chats.append(post)
                        }
                    }
                }
                
                self.chatTableView.reloadData()
        })
    }
    
    @IBAction func send(_ sender: Any) {
        
        dismissKeyboard()
        
        if tfMessage.text != nil && tfMessage.text != "" {
            if messageId == nil {
                
                let post: Dictionary<String, AnyObject> = [
                    "messages": tfMessage.text as AnyObject,
                    "sender": recipient as AnyObject
                ]
                
                let message: Dictionary<String, AnyObject> = [
                    "lastmessage": tfMessage.text as AnyObject,
                    "recipient": recipient as AnyObject
                ]
                
                let recipientMessage: Dictionary<String, AnyObject> = [
                    "lastmessage": tfMessage.text as AnyObject,
                    "recipient": currentUser as AnyObject
                ]
                
                messageId = Database.database().reference().child("messages").childByAutoId().key
                
                let firebaseMessage = Database.database().reference().child("messages").child(messageId).childByAutoId()
                
                firebaseMessage.setValue(post)
                
                let userMessage = Database.database().reference().child("users").child(currentUser!).child("messages").child(messageId)
                
                userMessage.setValue(message)
                
                
                let recipentMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
                
                recipentMessage.setValue(recipientMessage)
                
                
            }
        }
    }
    
    
}

extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = chats[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell {
            
            cell.configureCell(chat: chat)
            
            return cell
        }else{
        
            return ChatTableViewCell()
        }
        
    }
    
    
}

extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
