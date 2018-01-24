//
//  MeViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/9/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var userProfileImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        handleProfileImage()
        updateUserProfileImage()
    }
    
    func updateUserProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DataServices.instance.getUserProfileImageLink(withUID: uid) { (imageLink) in
            if imageLink != "" {
                if let imageURL = URL(string: imageLink) {
                    URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let imageData = data {
                            DispatchQueue.main.async {
                                self.userProfileImage.image = UIImage(data: imageData)
                            }
                        }
                    }).resume()
                }
            }
        }
    }
    
    //IBOutlets
    @IBAction func logoutUserBtnPressed(_ sender: UIButton) {
        
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Logout", style: .default) { action in
            
            AuthServices.instance.logoutUser { (success, error) in
                if success {
                    guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") else { return }
                    self.present(loginVC, animated: true, completion: nil)
                }else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        logoutAlert.addAction(cancelAction)
        logoutAlert.addAction(okAction)
        present(logoutAlert, animated: true, completion: nil)
        
    }
    
    //func to handle selected profileImage
    func handleProfileImage() {
        let tapToHandleProfileImage = UITapGestureRecognizer(target: self, action: #selector(MeViewController.handleToSelectProfileImage))
        userProfileImage.addGestureRecognizer(tapToHandleProfileImage)
        userProfileImage.isUserInteractionEnabled = true
    }
    
    @objc func handleToSelectProfileImage() {
        present(imagePicker, animated: true, completion: nil)
    }

}

extension MeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        }else if let originImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originImage
        }else {
            selectedImage = UIImage(named: "defaultProfileImage")
        }
        
        if selectedImage != nil {
            userProfileImage.image = selectedImage
        }
        
        if let image = userProfileImage.image {
            if let uploadedImageData = UIImagePNGRepresentation(image) {
                DataServices.instance.uploadImageToFirebaseStorage(withImageData: uploadedImageData, whenCompleted: { (success, metaData, error) in
                    if success {
                        if let downloadUrl = metaData?.downloadURL()?.absoluteString {
                            guard let uid = Auth.auth().currentUser?.uid else { return }
                            let userProfileImageInfo = ["userProfileImageURL": downloadUrl]
                            DataServices.instance.updateImageLinkToFirebaseUser(withUID: uid, andUserInfo: userProfileImageInfo)
                            self.updateUserProfileImage()
                        }
                    }else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
