//
//  UsersMessageTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/12/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class UsersMessageTableViewCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var userMessageLabel: UILabel!
    
    func configureCell(forMessageBody message: String, withProfileImage imageString: String, andProfileName name: String, atCurrentTime time: String){
        self.userMessageLabel.text = message
        self.userProfileNameLabel.text = name
        self.currentTimeLabel.text = "Post at \(time)"
        DataServices.instance.getUserProfileImage(withImageString: imageString) { (userImage) in
            DispatchQueue.main.async {
                self.userProfileImage.image = userImage
            }
        }
    }
    
}
