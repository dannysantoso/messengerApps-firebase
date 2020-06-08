//
//  Search.swift
//  dannymessenger
//
//  Created by danny santoso on 04/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Contact{
    private var _username:String!
    var _messageId:String!
    private var _userImg:String!
    private var _userKey:String!
    private var _userRef:DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid ")
    
    var username: String{
        return _username
    }
    
    var messageId: String{
        return _messageId
    }
    
    var userImg: String{
        return _userImg
    }
    
    var userKey: String{
        return _userKey
    }
    
    init(username: String, userImg: String, messageId: String) {
        
        _username = username
        _userImg = userImg
        _messageId = messageId
    }
    
    init(userKey: String, postData: Dictionary<String, AnyObject>, messageId: String) {
        
        _userKey = userKey
        
        if let username = postData["username"] as? String {
            
            _username = username
        }
        
        if let userImg = postData["userImg"] as? String {
            
            _userImg = userImg
        }
        
        _messageId = messageId
        
        _userRef = Database.database().reference().child("messages").child(_userKey)
    }
    
    
}
