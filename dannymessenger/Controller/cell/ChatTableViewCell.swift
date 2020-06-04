//
//  ChatTableViewCell.swift
//  dannymessenger
//
//  Created by danny santoso on 03/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper 


class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var receiveMessage: UILabel!
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var sentMessage: UILabel!
    @IBOutlet weak var sentView: UIView!
    
    var chat: Chat!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        receiveView.layer.cornerRadius = 5
        receiveView.layer.masksToBounds = true
        
        sentView.layer.cornerRadius = 5
        sentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(chat: Chat){
        
        self.chat = chat
        
        if chat.sender == currentUser {
            
            sentView.isHidden = true
            sentMessage.text = ""
            
            receiveView.isHidden = false
            receiveMessage.text = chat.chat
            
        } else {
            
            sentView.isHidden = false
            sentMessage.text = chat.chat
            
            receiveView.isHidden = true
            receiveMessage.text = ""
            
        }
        
    }
}
