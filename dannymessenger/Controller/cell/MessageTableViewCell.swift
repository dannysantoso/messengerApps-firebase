//
//  MessageTableViewCell.swift
//  dannymessenger
//
//  Created by danny santoso on 03/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var recipientImage: UIImageView!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var messagePreview: UILabel!
    
    var messageDetail: MessageDetail!
    var userPostKey: DatabaseReference!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid ")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(messageDetail: MessageDetail) {
        
        self.messageDetail = messageDetail
        
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["username"]
            
            let userImg = data["userImg"]
            
            self.recipientName.text = username as? String
            
            let ref = Storage.storage().reference(forURL: userImg! as! String)
            
            ref.getData(maxSize: 100000, completion: { (data, error) in
                
                if error != nil {
                    print("could not load image")
                } else {
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            //menampilkan gambar profile recipient ke cell image
                            self.recipientImage.image = img
                        }
                    }
                }
            })
        })
    }
    
}
