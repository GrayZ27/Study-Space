//
//  GroupChatViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/20/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit
import Firebase

class GroupChatViewController: UIViewController, UITextFieldDelegate {

    //UIOutLets
    @IBOutlet weak var groupChatTableView: UITableView!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    private var group: GroupData?
    private var groupMessageArray = [MessageData]()
    private var userEmailArray = [String]()
    private var userProfileImageLink = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTextField.delegate = self
        groupTextField.bindToKeyboard()
        groupChatTableView.bindToKeyboard()
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(GroupChatViewController.tapToDismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        groupChatTableView.estimatedRowHeight = 95
        groupChatTableView.rowHeight = UITableViewAutomaticDimension
        groupChatTableView.delegate = self
        groupChatTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.groupNameLabel.text = group?.groupName
        if group != nil {
            DataServices.instance.REF_GROUPS.child((group?.groupId)!).observe(.value, with: { (dataSnapShot) in
                DataServices.instance.getGroupMessageAndUserEmail(withGroup: self.group!, whenCompleted: { (messageArray, emailArray, userProfileImageLinkArray) in
                    self.groupMessageArray = messageArray
                    self.userEmailArray = emailArray
                    self.userProfileImageLink = userProfileImageLinkArray
                    self.groupChatTableView.reloadData()
                    if self.groupMessageArray.count > 0 {
                        self.groupChatTableView.scrollToRow(at: IndexPath(row: self.groupMessageArray.count - 1, section: 0), at: .none, animated: false)
                    }
                })
            })
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @objc private func tapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    func initGroup(forGroup group: GroupData) {
        self.group = group
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendingMessage()
        return true
    }
    
    private func sendingMessage() {
        if groupTextField.text != nil && groupTextField.text != "" {
            let sendingAlert = UIAlertController(title: "sending...", message: "Are you sure to send this message?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let sendAction = UIAlertAction(title: "Send", style: .destructive, handler: { (sendingAction) in
                let currentTime = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .medium)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                DataServices.instance.uploadPostToFirebase(withMessage: self.groupTextField.text!, andUID: uid, onTime: currentTime, withGroupKey: self.group?.groupId, whenCompleted: { (success) in
                    if success {
                        self.view.endEditing(true)
                        self.groupTextField.text = ""
                    }else {
                        self.toShowAlert(message: "Can't send your message now, please try again later.")
                    }
                })
            })
            sendingAlert.addAction(cancelAction)
            sendingAlert.addAction(sendAction)
            present(sendingAlert, animated: true, completion: nil)
        }else {
            toShowAlert(message: "Your sending content is not legal")
        }
    }
    
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    //UIActions
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismissDetail()
    }
    
    @IBAction func addMoreBtnPressed(_ sender: UIButton) {
        let moreActions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add Members", style: .default) { action in
            guard let addGroupMemberVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGroupMemberVC") as?  AddGroupMemberViewController else { return }
            if let members = self.group?.members {
                addGroupMemberVC.initGroupMembers(withGroupMembers: members)
                self.presentDetail(addGroupMemberVC)
            }
        }
        let quitAction = UIAlertAction(title: "Quit Group", style: .destructive) { action in
            let quitAlert = UIAlertController(title: "Quit", message: "Quit this group?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let quitAction = UIAlertAction(title: "Quit", style: .default, handler: { (action) in
                guard let myId = Auth.auth().currentUser?.uid else { return }
                guard let groupKey = self.group?.groupId else { return }
                if var members = self.group?.members {
                    var count = 0
                    for member in members {
                        if member == myId {
                            members.remove(at: count)
                        }else {
                            count += 1
                        }
                    }
                    if !members.contains(myId){
                        DataServices.instance.REF_GROUPS.child(groupKey).updateChildValues(["members" : members])
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            quitAlert.addAction(cancelAction)
            quitAlert.addAction(quitAction)
            self.present(quitAlert, animated: true, completion: nil)
        }
        moreActions.addAction(cancelAction)
        moreActions.addAction(addAction)
        moreActions.addAction(quitAction)
        present(moreActions, animated: true, completion: nil)
    }
    
}

extension GroupChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupMessageArray.count == userEmailArray.count {
            return groupMessageArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = groupMessageArray[indexPath.row]
        let imageName = userProfileImageLink[indexPath.row]
        
        if message.senderId == Auth.auth().currentUser?.uid {
            guard let cell = groupChatTableView.dequeueReusableCell(withIdentifier: "groupYourMessageCell") as? GroupYourMessagesTableViewCell else { return UITableViewCell() }
            cell.configureGroupYourMessageCell(forYourProfileImage: imageName, withYourMessage: message.messageBody, atCurrentTime: message.currentTime)
            return cell
        }else {
            guard let cell = groupChatTableView.dequeueReusableCell(withIdentifier: "groupUsersMessageCell") as? GroupUsersMessagesTableViewCell else { return UITableViewCell() }
            cell.configureGroupUserMessageCell(forUserProfileImage: imageName, withUserName: userEmailArray[indexPath.row], andUserMessage: message.messageBody, atCurrentTime: message.currentTime)
            return cell
        }
    }
}














