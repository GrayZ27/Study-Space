//
//  GroupTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/17/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupMemberCounts: UILabel!
    
    func configureGroupCell(forName name: String, andDescription description: String, withMemberCount count: Int) {
        groupNameLabel.text = name
        groupDescriptionLabel.text = description
        groupMemberCounts.text = "\(count) members"
    }
    
}
