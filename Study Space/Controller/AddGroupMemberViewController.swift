//
//  AddGroupMemberViewController.swift
//  Study Space
//
//  Created by Gray Zhen on 1/27/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class AddGroupMemberViewController: UIViewController {

    var groupMembers: [String]?
    
    func initGroupMembers(withGroupMembers member: [String]) {
        self.groupMembers = member
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupMembers != nil {
            print(groupMembers!)
        }
    }
    
    //UIActions
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismissDetail()
    }
    
}
