//
//  AddGroupMemberViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/27/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class AddGroupMemberViewController: UIViewController, UISearchBarDelegate {
    
    //UIOutlets
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var displayUsersTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var originGroupMembers = [String]()
    var updateGroupMembers = [String]()
    var emailArray = [String]()
    var profileImageArray = [String]()
    var userIdsArray = [String]()
    
    private var memberCount = 0
    private var fixedOriginMemberCount = 0
    
    private var groupId: String?
    
    func initGroupMembers(withGroupMembers member: [String]) {
        self.originGroupMembers = member
        self.updateGroupMembers = member
        self.memberCount = member.count
        self.fixedOriginMemberCount = member.count
    }
    
    func initGroupId(withId id: String) {
        groupId = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchBar.delegate = self
        displayUsersTableView.delegate = self
        displayUsersTableView.dataSource = self
        doneBtn.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            DataServices.instance.getEmailAndUserProfileImageLinkWithFilterMembers(searchByText: searchText.lowercased(), withFilterMembers: originGroupMembers, whenCompleted: { (emailArray, profileImageArray, userIdsArray) in
                self.emailArray = emailArray
                self.profileImageArray = profileImageArray
                self.userIdsArray = userIdsArray
                self.displayUsersTableView.reloadData()
            })
        }else {
            updateGroupMembers = originGroupMembers
            self.emailArray = []
            self.profileImageArray = []
            self.userIdsArray = []
            self.displayUsersTableView.reloadData()
        }
    }
    
    //UIActions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismissDetail()
    }
    
    @IBAction func doneBtnToAddMembersPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add member", message: "This memeber will be added to group.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let id = self.groupId {
                DataServices.instance.REF_GROUPS.child(id).updateChildValues(["members" : self.updateGroupMembers])
                self.dismissDetail()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension AddGroupMemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = displayUsersTableView.dequeueReusableCell(withIdentifier: "displayUserCell") as? SearchBarDisplayUserCell else { return UITableViewCell() }
        cell.configureUserCell(withProfileImage: profileImageArray[indexPath.row], andUserName: emailArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId = userIdsArray[indexPath.row]
        if !updateGroupMembers.contains(selectedId){
            updateGroupMembers.append(selectedId)
            memberCount += 1
        }
        checkToShowDoneBtn()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedId = userIdsArray[indexPath.row]
        if updateGroupMembers.contains(selectedId) {
            updateGroupMembers = updateGroupMembers.filter { $0 != selectedId }
            memberCount -= 1
        }
        checkToShowDoneBtn()
    }
    
    func checkToShowDoneBtn() {
        if memberCount > fixedOriginMemberCount {
            doneBtn.isHidden = false
        }else {
            doneBtn.isHidden = true
        }
    }
    
}


















