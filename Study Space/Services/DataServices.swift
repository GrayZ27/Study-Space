//
//  DataServices.swift
//  Study Space
//
//  Created by Gray Zhen on 1/4/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import Foundation
import Firebase

let DATABASE_BASE = Database.database().reference()
let DATABASE_STORAGE = Storage.storage().reference()

let imageCache = NSCache<AnyObject, AnyObject>()

class DataServices {
    
    static let instance = DataServices()
    
    private var _REF_BASE = DATABASE_BASE
    private var _REF_USERS = DATABASE_BASE.child("users")
    private var _REF_GROUPS = DATABASE_BASE.child("groups")
    private var _REF_BOARD = DATABASE_BASE.child("board")
    
    private var _REF_STORAGE_IMAGE = DATABASE_STORAGE.child("Images")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_BOARD: DatabaseReference {
        return _REF_BOARD
    }
    
    var REF_STORAGE_IMAGE: StorageReference {
        return _REF_STORAGE_IMAGE
    }
    
    //func to update userProfileImage to FIrebase Storage
    func uploadImageToFirebaseStorage(withImageData data: Data, whenCompleted complete: @escaping (_ success: Bool,  _ megaData: StorageMetadata?, _ error: Error?) -> ()) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let imageName = "\(userEmail)'s profileImage"
        REF_STORAGE_IMAGE.child("\(imageName).png").putData(data, metadata: nil) { (metaData, error) in
            if let error = error {
                complete(false, nil, error)
            }
            complete(true, metaData, nil)
        }
    }
    
    //func to update userProfileImage Link to Firebase
    func updateImageLinkToFirebaseUser(withUID uid: String, andUserInfo userInfo: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userInfo)
    }
    
    //func to get userProfileImageLink from Firebase
    func getUserProfileImageLink(withUID uid: String, whenCompleted complete: @escaping (_ imageLink: String) -> ()){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userDataSnapShot) in
            guard let userData = userDataSnapShot.value as? NSDictionary else { return }
            guard let imageLink = userData["userProfileImageURL"] as? String else { return }
            complete(imageLink)
        }
    }
    
    //func to create users in Firebase
    func createDatabaseUser(withUID uid: String, andUserInfo userInfo: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userInfo)
    }
    
    //func to upload post to Firebase
    func uploadPostToFirebase(withMessage message: String, andUID uid: String, onTime time: String, withGroupKey groupKey: String?, whenCompleted complete: @escaping (_ status: Bool) -> ()) {
        
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("message").childByAutoId().updateChildValues(["content": message, "senderId": uid, "currentTime": time])
            complete(true)
        }else {
            REF_BOARD.childByAutoId().updateChildValues(["content": message, "senderId": uid, "currentTime": time])
            complete(true)
        }
        
    }
    
    //func to create groups in Firebase
    func createDatabaseGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], whenCompleted complete: @escaping (_ status: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title" : title, "description" : description, "members" : ids])
        complete(true)
    }
    
    //func to get board message and User emails and profileImageLink from Firebase
    func getAllBoardMessagesAndUserEmails(whenCompleted complete: @escaping (_ message: [MessageData], _ userEmail: [String], _ userProfileImage: [String]) -> ()) {
        var messageDataArray = [MessageData]()
        var userEmailArray = [String]()
        var userProfileImageArray = [String]()
        
        REF_BOARD.observeSingleEvent(of: .value) { (boardMessageDataSnapShot) in
            self.REF_USERS.observeSingleEvent(of: .value, with: { (userDataSnapShot) in
                guard let boardMessageData = boardMessageDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
                guard let userData = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
                for message in boardMessageData {
                    for user in userData {
                        if message.childSnapshot(forPath: "senderId").value as! String == user.key {
                            let messageBody = message.childSnapshot(forPath: "content").value as! String
                            let senderId = message.childSnapshot(forPath: "senderId").value as! String
                            let currentTime = message.childSnapshot(forPath: "currentTime").value as! String
                            let userEmail = user.childSnapshot(forPath: "email").value as! String
                            if let userProfileImageString = user.childSnapshot(forPath: "userProfileImageURL").value as? String {
                                userProfileImageArray.append(userProfileImageString)
                            }else {
                                userProfileImageArray.append("")
                            }
                            let message = MessageData.init(forMessageBody: messageBody, withSenderId: senderId, atCurrentTime: currentTime)
                            messageDataArray.append(message)
                            userEmailArray.append(userEmail)
                        }
                    }
                }
                complete(messageDataArray, userEmailArray, userProfileImageArray)
            })
        }
    }
    
    // func to get user email and profile image by user search text
    func getEmailAndUserProfileImageLink(searchByText text: String, whenCompleted complete: @escaping (_ emailArray: [String], _ imageLink: [String]) -> ()) {
        var emailArray = [String]()
        var imageLinkArray = [String]()
        REF_USERS.observe(.value) { (userDataSnapShot) in
            guard let userData = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userData {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(text) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                    if let userProfileImageString = user.childSnapshot(forPath: "userProfileImageURL").value as? String {
                        imageLinkArray.append(userProfileImageString)
                    }else {
                        imageLinkArray.append("")
                    }
                }
            }
            complete(emailArray, imageLinkArray)
        }
    }
    
    // func to get user email and profile image by user search text with filter members
    func getEmailAndUserProfileImageLinkWithFilterMembers(searchByText text: String, withFilterMembers members: [String], whenCompleted complete: @escaping (_ emailArray: [String], _ imageLink: [String], _ userIds: [String]) -> ()) {
        var emailArray = [String]()
        var imageLinkArray = [String]()
        var userIdsArray = [String]()
        REF_USERS.observe(.value) { (userDataSnapShot) in
            guard let userData = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userData {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(text) == true && members.contains(user.key) == false {
                    emailArray.append(email)
                    userIdsArray.append(user.key)
                    if let userProfileImageString = user.childSnapshot(forPath: "userProfileImageURL").value as? String {
                        imageLinkArray.append(userProfileImageString)
                    }else {
                        imageLinkArray.append("")
                    }
                }
            }
            complete(emailArray, imageLinkArray, userIdsArray)
        }
    }
    
    //func to return user Image
    func getUserProfileImage(withImageString imageString: String, whenCompleted complete: @escaping (_ image: UIImage) -> ()){
        if imageString != "" {
            if let cachedImage = imageCache.object(forKey: imageString as AnyObject) as? UIImage{
                complete(cachedImage)
            }else {
                if let imageURL = URL(string: imageString){
                    URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                        if let err = error {
                            if let image = UIImage(named: "defaultProfileImage"){
                                complete(image)
                            }
                            print(err.localizedDescription)
                        }else {
                            if let imageData = data {
                                if let downloadedImage = UIImage(data: imageData){
                                    imageCache.setObject(downloadedImage, forKey: imageString as AnyObject)
                                    complete(downloadedImage)
                                }
                            }
                        }
                    }).resume()
                }
            }
        }else {
            if let image = UIImage(named: "defaultProfileImage"){
                complete(image)
            }
        }
    }

    //func to get login user posts and the posts id
    func getCurrentLoginUserPosts(whenCompleted complete: @escaping (_ messageData: [MessageData], _ postsID: [String]) -> ()) {
        var messageDataArray = [MessageData]()
        var postsIdArray = [String]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_BOARD.observeSingleEvent(of: .value) { (messageDataSnapShot) in
            guard let messageData = messageDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for message in messageData {
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                if senderId == uid {
                    let messageBody = message.childSnapshot(forPath: "content").value as! String
                    let time = message.childSnapshot(forPath: "currentTime").value as! String
                    let data = MessageData.init(forMessageBody: messageBody, withSenderId: senderId, atCurrentTime: time)
                    messageDataArray.append(data)
                    postsIdArray.append(message.key)
                }
            }
            complete(messageDataArray,postsIdArray)
        }
    }
    
    //func to get current login user image
    func getCurrentLoginUserImage(whenCompleted complete: @escaping (_ userImage: UIImage) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DataServices.instance.getUserProfileImageLink(withUID: uid) { (imageLink) in
            if imageLink != "" {
                if let cachedImage = imageCache.object(forKey: imageLink as AnyObject) as? UIImage{
                    complete(cachedImage)
                }else {
                    if let imageURL = URL(string: imageLink) {
                        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                            if let err = error {
                                if let image = UIImage(named: "defaultProfileImage"){
                                    complete(image)
                                }
                                print(err.localizedDescription)
                            }else {
                                if let imageData = data {
                                    DispatchQueue.main.async {
                                        if let downloadedImage = UIImage(data: imageData){
                                            imageCache.setObject(downloadedImage, forKey: imageLink as AnyObject)
                                            complete(downloadedImage)
                                        }
                                    }
                                }
                            }
                        }).resume()
                    }
                }
            }else {
                if let image = UIImage(named: "defaultProfileImage"){
                    complete(image)
                }
            }
        }
    }
    
    // get user ids array from user email array
    func getUserIds(forUserEmailsArray emailArray: [String], whenCompleted complete: @escaping (_ userIdsArray: [String]) -> ()) {
        var userIdsArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (userDataSnapShot) in
            guard let userData = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userData {
                let email = user.childSnapshot(forPath: "email").value as! String
                if emailArray.contains(email) {
                    userIdsArray.append(user.key)
                }
            }
            complete(userIdsArray)
        }
    }
    
    //get all group from group view controller
    func getGroups(whenCompleted complete: @escaping (_ groupsArray: [GroupData]) -> ()) {
        var groupsArray = [GroupData]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupDataSnapShot) in
            guard let groupData = groupDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupData {
                let groupMembers = group.childSnapshot(forPath: "members").value as! [String]
                guard let me = Auth.auth().currentUser?.uid else { return }
                if groupMembers.contains(me){
                    let groupName = group.childSnapshot(forPath: "title").value as! String
                    let groupDescription = group.childSnapshot(forPath: "description").value as! String
                    let groupId = group.key
                    let groupMemberCount = groupMembers.count
                    let groupData = GroupData.init(forGroupName: groupName, andDescription: groupDescription, withGroupId: groupId, andGroupMembers: groupMembers, withMemberCount: groupMemberCount)
                    groupsArray.append(groupData)
                }
            }
            complete(groupsArray)
        }
    }
    
    //func to get groupmessage and userEmail and profileImageLink from Firebase
    func getGroupMessageAndUserEmail(withGroup group: GroupData, whenCompleted complete: @escaping (_ messageArray: [MessageData], _ emailArray: [String], _ userProfileImage: [String]) -> ()) {
        var messageArray = [MessageData]()
        var emailArray = [String]()
        var userProfileImageLinkArray = [String]()
        
        REF_GROUPS.child(group.groupId).child("message").observeSingleEvent(of: .value) { (groupMessageDataSnapShot) in
            self.REF_USERS.observeSingleEvent(of: .value, with: { (userDataSnapShot) in
                guard let messageData = groupMessageDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
                guard let userData = userDataSnapShot.children.allObjects as? [DataSnapshot] else { return }
                for message in messageData {
                    for user in userData {
                        let senderId = message.childSnapshot(forPath: "senderId").value as! String
                        if senderId == user.key {
                            let messageBody = message.childSnapshot(forPath: "content").value as! String
                            let currentTime = message.childSnapshot(forPath: "currentTime").value as! String
                            let userEmail = user.childSnapshot(forPath: "email").value as! String
                            if let userProfileImageString = user.childSnapshot(forPath: "userProfileImageURL").value as? String {
                                userProfileImageLinkArray.append(userProfileImageString)
                            }else {
                                userProfileImageLinkArray.append("")
                            }
                            let message = MessageData.init(forMessageBody: messageBody, withSenderId: senderId, atCurrentTime: currentTime)
                            messageArray.append(message)
                            emailArray.append(userEmail)
                        }
                    }
                }
                complete(messageArray,emailArray, userProfileImageLinkArray)
            })
        }
    }
}
