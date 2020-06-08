//
//  ChatDetail.swift
//  dannymessenger
//
//  Created by danny santoso on 03/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper


class MessageDetail {
    private var _recipient:String!
    private var _lastmessage:String!
    private var _messageKey:String!
    private var _messageRef:DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid ")
    var recipient: String{
        return _recipient
    }
    
    var lastmessage: String{
        return _lastmessage
    }
    
    var messageKey: String{
        return _messageKey
    }
    
    var messageRef: DatabaseReference{
        return _messageRef
    }
    
    init(recipient: String, lastmessage: String) {
        
        _recipient = recipient
        _lastmessage = lastmessage
    }
    
    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let recipient = messageData["recipient"] as? String {
            
            _recipient = recipient
        }
        
        if let lastmessage = messageData["lastmessage"] as? String {
            
            _lastmessage = lastmessage
        }
        
        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
    }
    
}
