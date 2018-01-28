//
//  SearchBarDisplayUserCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/28/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class SearchBarDisplayUserCell: UITableViewCell {

    //UIOutlets
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    func configureUserCell(withProfileImage imageString: String, andUserName name: String) {
        userNameLabel.text = name
        DataServices.instance.getUserProfileImage(withImageString: imageString) { (userImage) in
            DispatchQueue.main.async {
                self.userProfileImage.image = userImage
            }
        }
    }

}
