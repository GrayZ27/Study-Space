//
//  YourMessageTableViewCell.swift
//  Study Space
//
//  Created by Gray Zhen on 1/12/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import UIKit

class YourMessageTableViewCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var yourProfileImage: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var yourMessageLabel: UILabel!
    
    func configureYourMessageCell(forMessageBody message: String, withProfileImage imageString: String, atCurrentTime time: String) {
        yourMessageLabel.text = message
        currentTimeLabel.text = "Post at \(time)"
        DataServices.instance.getUserProfileImage(withImageString: imageString) { (userImage) in
            DispatchQueue.main.async {
                self.yourProfileImage.image = userImage
            }
        }
    }
    
}
