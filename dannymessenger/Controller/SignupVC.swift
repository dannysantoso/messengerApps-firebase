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
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    var userUid:String!
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var username:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }


    
    //ngedisplay image picker untuk memilih gambar dari library, photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            userImage.image = image
            
            imageSelected = true
            
        } else {
            
            print("image wasnt selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //menyimpan data ke dalam firebase database
    func setUser(img: String){
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        //menyimpan id ke keychainwrapper = ini mirip dengan user default
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        
        //menyimpan datanya ke firebase database
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        
        //membuat rootviewcontroller baru ke message view controller
        let destination = MessageVC(nibName: "MessageVC", bundle: nil)
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [destination]
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    

    //upload image ke firebase storage
    func uploadImage(){

        username = tfUsername.text

        guard let image = userImage.image, imageSelected == true else{
            print("Image must be selected")
            return
        }
        
        
        //menyimpan gambar ke dalam firebase storage
        
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
        
        //membuat akun pada firebase authentication
        if tfEmail != nil && tfPassword != nil && tfUsername != nil && imageSelected == true {
            Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!, completion: { (user, error) in
                if error != nil {
                    print(error)
                }else{
                    if let user = user {
                        self.userUid = user.user.uid
                    }
                    self.uploadImage()
                }
                
                
            })
        }else{
            print("please fill all the form")
            let alert = UIAlertController(title: nil, message: "please fill all the form", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //menampilkan imagepicker
    @IBAction func selectedImagePicker(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    

}
