//
//  CreateGroupViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/13/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITextFieldDelegate {

    //UIOutlets
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var groupNameTextField: CustomUITextField!
    @IBOutlet weak var groupDescriptionTextField: CustomUITextField!
    @IBOutlet weak var addGroupMemberTextField: CustomUITextField!
    @IBOutlet weak var groupMembersLabel: UILabel!
    @IBOutlet weak var searchedUsersTableView: UITableView!
    
    private var searchEmailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        groupDescriptionTextField.delegate = self
        addGroupMemberTextField.delegate = self
        searchedUsersTableView.delegate = self
        searchedUsersTableView.dataSource = self
        doneBtn.isEnabled = false
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
            DataServices.instance.getEmail(searchByText: searchText, whenCompleted: { (emailArray) in
                self.searchEmailArray = emailArray
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
    
    
    
    //UIActions
    @IBAction func closeCreateGroupBtnPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneCreateGroupBtnPressed(_ sender: UIButton) {
        
    }
    
}

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "displaySearchedUsersCell") as? addGroupMembersTableViewCell else { return UITableViewCell() }
        let email = searchEmailArray[indexPath.row]
        cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, userName: email, isSelected: true)
        return cell
    }
    
}


















