//
//  ViewController.swift
//  dannymessenger
//
//  Created by danny santoso on 01/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var userUid: String!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            let destination = MessageVC(nibName: "ChatVC", bundle: nil)
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signIn(_ sender: Any) {
        
        if let email = tfEmail.text, let password = tfPassword.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    self.userUid = user?.user.uid
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    
                    let destination = MessageVC(nibName: "ChatVC", bundle: nil)
                    
                    self.navigationController?.pushViewController(destination, animated: true)
                    
                }else{
                    let destination = SignupVC(nibName: "SignupVC", bundle: nil)
                    
                    destination.userUid = self.userUid
                    destination.emailField = self.tfEmail.text
                    destination.passwordField = self .tfPassword.text
                    
                    self.present(destination, animated: true, completion: nil)
                }
            })
        }
    }
}

