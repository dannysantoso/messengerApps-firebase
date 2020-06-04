//
//  SignupVC.swift
//  dannymessenger
//
//  Created by danny santoso on 02/06/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftKeychainWrapper

class SignupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userUid:String!
    var emailField:String!
    var passwordField:String!
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var username:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            let destination = MessageVC(nibName: "MessageVC", bundle: nil)
            
            self.present(destination, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            userImage.image = image
            
            imageSelected = true
            
        } else {
            
            print("image wasnt selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUser(img: String){
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImage(){
        if tfUsername.text == nil {
            signUpButton.isEnabled = false
        }else{
            username = tfUsername.text
            signUpButton.isEnabled = true
        }
        guard let image = userImage.image, imageSelected == true else{
            print("Image must be selected")
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.2){
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageRef = Storage.storage().reference().child(imgUid)
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in

                    if error != nil {
                        print("did not upload img")
                        return
                    } else {
                        storageRef.downloadURL(completion: {(url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        let downloadURL = url?.absoluteString
                        
                        if let url = downloadURL {
                            
                            self.setUser(img: url)
                        }
                    }
                )}
            }
        
        }
    }
    
    @IBAction func createAccount(_ sender: Any){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user, error) in
            if error != nil {
                print("Can't Create User")
            }else{
                if let user = user {
                    self.userUid = user.user.uid
                }
            }
            
            self.uploadImage()
        })
    }

    @IBAction func selectedImagePicker(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
