//
//  GroupYourMessagesTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/20/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class GroupYourMessagesTableViewCell: UITableViewCell {

    //UIOutlets
    @IBOutlet weak var yourProfileImage: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var yourMessageLabel: UILabel!
    
    func configureGroupYourMessageCell(forYourProfileImage image: UIImage, withYourMessage message: String, atCurrentTime time: String) {
        yourProfileImage.image = image
        yourMessageLabel.text = message
        currentTimeLabel.text = time
    }
    
}
