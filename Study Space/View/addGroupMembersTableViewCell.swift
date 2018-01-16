//
//  addGroupMembersTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/16/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class addGroupMembersTableViewCell: UITableViewCell {

    //UIOutlets
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSelectedMark: UIImageView!
    
    func configureCell(profileImage image: UIImage, userName name: String, isSelected: Bool) {
        usersImage.image = image
        userNameLabel.text = name
        userSelectedMark.isHidden = !isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            print("I was selected")
        }
    }
    
}
