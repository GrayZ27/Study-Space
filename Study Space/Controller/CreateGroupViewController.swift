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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        groupDescriptionTextField.delegate = self
        addGroupMemberTextField.delegate = self
        doneBtn.isEnabled = false
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateGroupViewController.tapToDismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
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

