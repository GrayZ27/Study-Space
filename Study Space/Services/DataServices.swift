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

class DataServices {
    
    static let instance = DataServices()
    
    private var _REF_BASE = DATABASE_BASE
    private var _REF_USERS = DATABASE_BASE.child("users")
    private var _REF_GROUPS = DATABASE_BASE.child("groups")
    private var _REF_BOARD = DATABASE_BASE.child("board")
    
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
    
    //func to create users in Firebase
    func createDatabaseUser(withUID uid: String, andUserInfo userInfo: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userInfo)
    }
    
    //func to upload post to Firebase
    func uploadPostToFirebase(withMessage message: String, andUID uid: String, onTime time: String, withGroupKey groupKey: String?, whenCompleted complete: @escaping (_ status: Bool) -> ()) {
        
        if groupKey != nil {
            //Will post this message to group
        }else {
            REF_BOARD.childByAutoId().updateChildValues(["content": message, "senderId": uid, "currentTime": time])
            complete(true)
        }
        
    }
    
    //func to get board message and User emails from Firebase
    func getAllBoardMessagesAndUserEmails(whenCompleted complete: @escaping (_ message: [MessageData], _ userEmail: [String]) -> ()) {
        var messageDataArray = [MessageData]()
        var userEmailArray = [String]()
        
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
                            let message = MessageData.init(forMessageBody: messageBody, withSenderId: senderId, atCurrentTime: currentTime)
                            messageDataArray.append(message)
                            userEmailArray.append(userEmail)
                        }
                    }
                }
                complete(messageDataArray, userEmailArray)
            })
        }
    }

}














