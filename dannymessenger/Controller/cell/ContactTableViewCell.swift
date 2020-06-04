//
//  ContactTableViewCell.swift
//  dannymessenger
//
//  Created by danny santoso on 04/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper


class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    var contact:Contact!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(contact: Contact){
        
        self.contact = contact
        
        contactName.text = contact.username
        
        let ref = Storage.storage().reference(forURL: contact.userImg)
        ref.getData(maxSize: 1000000, completion: {
            data, error in
                if error != nil {
                    print(error)
                }else{
                    if let imgData = data {
                        
                        if let image = UIImage(data: imgData) {
                            
                            self.contactImage.image = image
                            
                        }
                        
                    }
                }
            
        })
    }
}
