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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func signIn(_ sender: Any) {
        
        
        //mengecek apakah dia berhasil login apa tidak menggunakan firebase authentication
        if let email = tfEmail.text, let password = tfPassword.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    self.userUid = user?.user.uid
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    
                    
                    
                    //ngebuat rootviewcontroller baru, jika user berhasil login
                    
                    let destination = MessageVC(nibName: "MessageVC", bundle: nil)
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [destination]
                    self.view.window?.rootViewController = navigationController
                    self.view.window?.makeKeyAndVisible()
                    
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                }else{

                    print("there is no account")
                    
                    let alert = UIAlertController(title: nil, message: "the account that you input doesn't match or the account has not been created", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    @IBAction func signUp(_ sender: Any) {
        let destination = SignupVC(nibName: "SignupVC", bundle: nil)
                            
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

