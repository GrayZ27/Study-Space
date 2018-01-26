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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPostsTabelView: UITableView!
   
    let imagePicker = UIImagePickerController()
    
    private var userPosts = [MessageData]()
    private var postIds = [String]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        handleProfileImage()
        updateUserProfileImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserMessageLoaded()
    }
    
    private func getUserMessageLoaded() {
        DataServices.instance.getCurrentLoginUserPosts { (messageDataArray, postsIds) in
            self.userPosts = messageDataArray.reversed()
            self.postIds = postsIds.reversed()
            self.userPostsTabelView.reloadData()
        }
    }
    
    private func setUpView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        userPostsTabelView.delegate = self
        userPostsTabelView.dataSource = self
        userPostsTabelView.estimatedRowHeight = 75
        userPostsTabelView.rowHeight = UITableViewAutomaticDimension
        userNameLabel.text = Auth.auth().currentUser?.email
    }
    
    func updateUserProfileImage() {
        DataServices.instance.getCurrentLoginUserImage { (userImage) in
            DispatchQueue.main.async {
                self.userProfileImage.image = userImage
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
            if let uploadedImageData = UIImageJPEGRepresentation(image, 0.1) {
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

extension MeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = userPostsTabelView.dequeueReusableCell(withIdentifier: "userPostsCell") as? UserPostsCell else { return UITableViewCell() }
        let messageData = userPosts[indexPath.row]
        cell.configureUserPostsCell(withPostBody: messageData.messageBody, andPostTime: "Post at \(messageData.currentTime)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let postId = self.postIds[indexPath.row]
            DataServices.instance.REF_BOARD.child(postId).removeValue()
            self.getUserMessageLoaded()
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return [deleteAction]
    }
    
}



















