//
//  GroupUsersMessagesTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/20/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class GroupUsersMessagesTableViewCell: UITableViewCell {

    //UIOutlets
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    func configureGroupUserMessageCell(forUserProfileImage image: String, withUserName name: String, andUserMessage message: String, atCurrentTime time: String) {
        userProfileImage.image = UIImage(named: image)
        userNameLabel.text = name
        userMessageLabel.text = message
        currentTimeLabel.text = time
    }

}
