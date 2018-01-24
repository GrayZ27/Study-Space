//
//  CreateGroupViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/13/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController, UITextFieldDelegate {

    //UIOutlets
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var groupNameTextField: CustomUITextField!
    @IBOutlet weak var groupDescriptionTextField: CustomUITextField!
    @IBOutlet weak var addGroupMemberTextField: CustomUITextField!
    @IBOutlet weak var searchedUsersTableView: UITableView!
    @IBOutlet weak var displayGroupMemeberView: UIView!
    @IBOutlet weak var displaySelectedGroupMembersLabel: UILabel!
    
    private var searchEmailArray = [String]()
    private var selectedEmailArray = [String]()
    private var userProfileImageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        groupDescriptionTextField.delegate = self
        addGroupMemberTextField.delegate = self
        searchedUsersTableView.delegate = self
        searchedUsersTableView.dataSource = self
        doneBtn.isEnabled = false
        displayGroupMemeberView.isHidden = true
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateGroupViewController.tapToDismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
        addGroupMemberTextField.addTarget(self, action: #selector(CreateGroupViewController.searchEmailByText), for: .editingChanged)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @objc private func searchEmailByText() {
        if addGroupMemberTextField.text == "" {
            searchEmailArray = []
            searchedUsersTableView.reloadData()
        }else {
            guard let searchText = addGroupMemberTextField.text else { return }
            DataServices.instance.getEmailAndUserProfileImageLink(searchByText: searchText, whenCompleted: { (emailArray, userProfileImageArray) in
                self.searchEmailArray = emailArray
                self.userProfileImageArray = userProfileImageArray
                self.searchedUsersTableView.reloadData()
            })
        }
    }
    
    @objc private func tapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func toShowAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    //UIActions
    @IBAction func closeCreateGroupBtnPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneCreateGroupBtnPressed(_ sender: UIButton) {
        
        if groupNameTextField.text != nil && groupNameTextField.text != "" {
            let title = groupNameTextField.text!
            var description = ""
            if groupDescriptionTextField.text != "" && groupDescriptionTextField.text != nil{
                description = groupDescriptionTextField.text!
            }else {
                description = "This group has no description"
            }
            DataServices.instance.getUserIds(forUserEmailsArray: selectedEmailArray, whenCompleted: { (userIdsArray) in
                var userIds = userIdsArray
                guard let myIds = Auth.auth().currentUser?.uid else { return }
                userIds.append(myIds)
                DataServices.instance.createDatabaseGroup(withTitle: title, andDescription: description, forUserIds: userIds, whenCompleted: { (success) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        self.toShowAlert(message: "Can't create group now, please try again later")
                    }
                })
            })
        }else {
            toShowAlert(message: "Your group title has not set")
        }
        
    }
    
    @IBAction func hideSelectedGroupMembersViewBtnPressed(_ sender: UIButton) {
        displayGroupMemeberView.isHidden = true
    }
    
}

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchEmailArray.count == userProfileImageArray.count {
            return searchEmailArray.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "displaySearchedUsersCell") as? addGroupMembersTableViewCell else { return UITableViewCell() }
        let email = searchEmailArray[indexPath.row]
        let profileImageString = userProfileImageArray[indexPath.row]
        if selectedEmailArray.contains(email){
            cell.configureCell(profileImage: profileImageString, userName: email, isSelected: true)
        }else {
            cell.configureCell(profileImage: profileImageString, userName: email, isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? addGroupMembersTableViewCell else { return }
        guard let userName = cell.userNameLabel.text else { return }
        if !selectedEmailArray.contains(userName) {
            selectedEmailArray.append(userName)
            displaySelectedGroupMembersLabel.text = selectedEmailArray.joined(separator: ", ")
            doneBtn.isEnabled = true
            displayGroupMemeberView.isHidden = false
        }else {
            selectedEmailArray = selectedEmailArray.filter({ $0 != userName})
            if selectedEmailArray.count > 0 {
                displaySelectedGroupMembersLabel.text = selectedEmailArray.joined(separator: ", ")
                displayGroupMemeberView.isHidden = false
            }else {
                doneBtn.isEnabled = false
                displayGroupMemeberView.isHidden = true
            }
        }
        
    }
    
}


















