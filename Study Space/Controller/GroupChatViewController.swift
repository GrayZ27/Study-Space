//
//  GroupChatViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/20/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class GroupChatViewController: UIViewController, UITextFieldDelegate {

    //UIOutLets
    @IBOutlet weak var groupChatTableView: UITableView!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    private var group: GroupData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTextField.delegate = self
        groupTextField.bindToKeyboard()
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(GroupChatViewController.tapToDismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.groupNameLabel.text = group?.groupName
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
        textField.resignFirstResponder()
        return true
    }
    
    
    //UIActions
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendGroupMessageBtnWasPressed(_ sender: UIButton) {
    }
    
}
