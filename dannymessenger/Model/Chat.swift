//
//  Chat.swift
//  dannymessenger
//
//  Created by danny santoso on 04/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Chat{
    private var _chat:String!
    private var _sender:String!
    private var _messageKey:String!
    private var _messageRef:DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid ")
    
    var chat: String{
        return _chat
    }
    
    var sender: String{
        return _sender
    }
    
    var messageKey: String{
        return _messageKey
    }
    
    init(chat: String, sender: String) {
        
        _chat = chat
        _sender = sender
    }
    
    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let chat = postData["message"] as? String {
            
            _chat = chat
        }
        
        if let sender = postData["sender"] as? String {
            
            _sender = sender
        }
        
        _messageRef = Database.database().reference().child("messages").child(_messageKey)
    }
    
    
}
